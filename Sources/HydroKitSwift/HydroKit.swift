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
        zrxp.stations.compactMap { station in
            guard let name = station.name else { return nil }
            guard let number = station.number else { return nil }
            guard let timeZoneIdentifier = station.timeZone else { return nil }
            guard let timeZone = TimeZone(identifier: timeZoneIdentifier) else { return nil }

            let water = station.water

            switch measurementType {
            case .airTemperature:
                let timeSeries = parse(station: station, timeZone: timeZone).map { TemperatureTimeSeriesEntry(value: $0.value, updateDate: $0.updateDate) }

                return Station(number: number, name: name, water: water, timeZone: timeZone, airTemperatureTimeSeries: timeSeries)
            case .groundwaterLevel:
                let timeSeries = parse(station: station, timeZone: timeZone).map { WaterLevelTimeSeriesEntry(value: $0.value, updateDate: $0.updateDate) }

                return Station(number: number, name: name, water: water, timeZone: timeZone, groundwaterLevelTimeSeries: timeSeries)
            case .groundwaterTemperature:
                let timeSeries = parse(station: station, timeZone: timeZone).map { TemperatureTimeSeriesEntry(value: $0.value, updateDate: $0.updateDate) }

                return Station(number: number, name: name, water: water, timeZone: timeZone, groundwaterTemperatureTimeSeries: timeSeries)
            case .rainfall:
                let timeSeries = parse(station: station, timeZone: timeZone).map { RainfallTimeSeriesEntry(value: $0.value, updateDate: $0.updateDate) }

                return Station(number: number, name: name, water: water, timeZone: timeZone, rainFallTimeSeries: timeSeries)
            case .surfaceWaterLevel:
                let timeSeries = parse(station: station, timeZone: timeZone).map { WaterLevelTimeSeriesEntry(value: $0.value, updateDate: $0.updateDate) }

                return Station(number: number, name: name, water: water, timeZone: timeZone, surfaceWaterLevelTimeSeries: timeSeries)
            case .surfaceWaterTemperature:
                let timeSeries = parse(station: station, timeZone: timeZone).map { TemperatureTimeSeriesEntry(value: $0.value, updateDate: $0.updateDate) }

                return Station(number: number, name: name, water: water, timeZone: timeZone, surfaceWaterTemperatureTimeSeries: timeSeries)
            }
        }
    }

    private func parse(station: ZRXPSwift.Station, timeZone: TimeZone) -> [(value: Double, updateDate: Date)] {
        station.timeSeriesValues.compactMap { timeSeriesValue -> (value: Double, updateDate: Date)? in
            guard let layoutCount = station.layout?.count else { return nil }
            guard timeSeriesValue.count == layoutCount && timeSeriesValue.count >= 2 else { return nil }

            let rawDate = timeSeriesValue[0]
            let rawRainfall = timeSeriesValue[1]

            // Filter out invalid data
            guard rawRainfall != station.invalidDataRecordValue else { return nil }

            guard let value = Double(rawRainfall) else { return nil }
            guard let updateDate = DateFormatter.zrxpFormatter(timeZone: timeZone).date(from: rawDate) else { return nil }

            return (value, updateDate)
        }
    }
}
