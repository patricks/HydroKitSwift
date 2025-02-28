//
//  HydroKit.swift
//
//
//  Created by Patrick Steiner on 03.02.24.
//

import Foundation
import ZRXPSwift

extension DateFormatter {
    fileprivate static func zrxpFormatter(timeZone: TimeZone) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.timeZone = timeZone

        return dateFormatter
    }
}

public struct HydroKit: Sendable {
    public init() {}

    /// Parse ZRXP stations from a given file URL and convert them into HydroKit stations.
    public func parseStations(fileURL: URL, measurementType: MeasurementType) -> [Station] {
        guard let zrxp = ZRXP(from: fileURL) else { return [] }

        return parseStations(zrxp: zrxp, measurementType: measurementType)
    }

    /// Parse ZRXP stations and convert them into HydroKit stations.
    public func parseStations(zrxp: ZRXP, measurementType: MeasurementType) -> [Station] {
        let stations = zrxp.stations.compactMap { station in
            if let name = station.name, let number = station.number {
                let water = station.water

                switch measurementType {
                case .airTemperature:
                    let airTemperatureTimeSeries = parseTemperatureTimeSeries(station: station)

                    return Station(number: number, name: name, water: water, airTemperatureTimeSeries: airTemperatureTimeSeries)
                case .groundwaterLevel:
                    let groundwaterLevelTimeSeries = parseWaterLevelTimeSeries(station: station)

                    return Station(number: number, name: name, water: water, groundwaterLevelTimeSeries: groundwaterLevelTimeSeries)
                case .groundwaterTemperature:
                    let groundwaterTemperatureTimeSeries = parseTemperatureTimeSeries(station: station)

                    return Station(number: number, name: name, water: water, groundwaterTemperatureTimeSeries: groundwaterTemperatureTimeSeries)
                case .rainfall:
                    let rainfallTimeSeries = parseRainfallTimeSeries(station: station)

                    return Station(number: number, name: name, water: water, rainFallTimeSeries: rainfallTimeSeries)
                case .surfaceWaterLevel:
                    let surfaceWaterLevelTimeSeries = parseWaterLevelTimeSeries(station: station)

                    return Station(number: number, name: name, water: water, surfaceWaterLevelTimeSeries: surfaceWaterLevelTimeSeries)
                case .surfaceWaterTemperature:
                    let surfaceWaterTemperatureTimeSeries = parseTemperatureTimeSeries(station: station)

                    return Station(number: number, name: name, water: water, surfaceWaterTemperatureTimeSeries: surfaceWaterTemperatureTimeSeries)
                }
            } else {
                return nil
            }
        }

        return stations
    }

    private func parseTemperatureTimeSeries(station: ZRXPSwift.Station) -> [TemperatureTimeSeriesEntry] {
        var temperatureTimeSeriesEntries = [TemperatureTimeSeriesEntry]()

        for timeSeriesValue in station.timeSeriesValues {
            guard let layoutCount = station.layout?.count else { continue }
            guard timeSeriesValue.count == layoutCount && timeSeriesValue.count >= 2 else { continue }

            let rawDate = timeSeriesValue[0]
            let rawTemperature = timeSeriesValue[1]

            // Filter out invalid data
            guard rawTemperature != station.invalidDataRecordValue else { continue }

            guard let temperature = Double(rawTemperature) else { continue }

            let timeZoneIdentifier = station.timeZone ?? "UTC"  // Use UTC as fallback
            guard let timeZone = TimeZone(identifier: timeZoneIdentifier) else { continue }
            guard let updateDate = DateFormatter.zrxpFormatter(timeZone: timeZone).date(from: rawDate) else { continue }

            let temperatureTimeSeriesEntry = TemperatureTimeSeriesEntry(value: temperature, updateDate: updateDate)

            temperatureTimeSeriesEntries.append(temperatureTimeSeriesEntry)
        }

        return temperatureTimeSeriesEntries
    }

    private func parseWaterLevelTimeSeries(station: ZRXPSwift.Station) -> [WaterLevelTimeSeriesEntry] {
        var waterLevelTimeSeriesEntries = [WaterLevelTimeSeriesEntry]()

        for timeSeriesValue in station.timeSeriesValues {
            guard let layoutCount = station.layout?.count else { continue }
            guard timeSeriesValue.count == layoutCount && timeSeriesValue.count >= 2 else { continue }

            let rawDate = timeSeriesValue[0]
            let rawWaterLevel = timeSeriesValue[1]

            // Filter out invalid data
            guard rawWaterLevel != station.invalidDataRecordValue else { continue }

            guard let waterLevel = Double(rawWaterLevel) else { continue }

            let timeZoneIdentifier = station.timeZone ?? "UTC"  // Use UTC as fallback
            guard let timeZone = TimeZone(identifier: timeZoneIdentifier) else { continue }
            guard let updateDate = DateFormatter.zrxpFormatter(timeZone: timeZone).date(from: rawDate) else { continue }

            let waterLevelTimeSeriesEntry = WaterLevelTimeSeriesEntry(value: waterLevel, updateDate: updateDate)

            waterLevelTimeSeriesEntries.append(waterLevelTimeSeriesEntry)
        }

        return waterLevelTimeSeriesEntries
    }

    private func parseRainfallTimeSeries(station: ZRXPSwift.Station) -> [RainfallTimeSeriesEntry] {
        var rainfallTimeSeriesEntries = [RainfallTimeSeriesEntry]()

        for timeSeriesValue in station.timeSeriesValues {
            guard let layoutCount = station.layout?.count else { continue }
            guard timeSeriesValue.count == layoutCount && timeSeriesValue.count >= 2 else { continue }

            let rawDate = timeSeriesValue[0]
            let rawRainfall = timeSeriesValue[1]

            // Filter out invalid data
            guard rawRainfall != station.invalidDataRecordValue else { continue }

            guard let rainfall = Double(rawRainfall) else { continue }

            let timeZoneIdentifier = station.timeZone ?? "UTC"  // Use UTC as fallback
            guard let timeZone = TimeZone(identifier: timeZoneIdentifier) else { continue }
            guard let updateDate = DateFormatter.zrxpFormatter(timeZone: timeZone).date(from: rawDate) else { continue }

            let rainfallTimeSeriesEntry = RainfallTimeSeriesEntry(value: rainfall, updateDate: updateDate)

            rainfallTimeSeriesEntries.append(rainfallTimeSeriesEntry)
        }

        return rainfallTimeSeriesEntries
    }
}
