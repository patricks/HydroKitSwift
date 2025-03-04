//
//  Station.swift
//
//
//  Created by Patrick Steiner on 30.08.23.
//

import Foundation

public struct Station: Identifiable, Sendable {
    public let number: String
    public let name: String
    public let water: String?
    public let timeZone: TimeZone

    public var id: String { number }

    public let airTemperatureTimeSeries: [TemperatureTimeSeriesEntry]
    public let rainfallTimeSeries: [RainfallTimeSeriesEntry]
    public let groundwaterLevelTimeSeries: [WaterLevelTimeSeriesEntry]
    public let groundwaterTemperatureTimeSeries: [TemperatureTimeSeriesEntry]
    public let surfaceWaterLevelTimeSeries: [WaterLevelTimeSeriesEntry]
    public let surfaceWaterTemperatureTimeSeries: [TemperatureTimeSeriesEntry]

    public init(
        number: String,
        name: String,
        water: String?,
        timeZone: TimeZone,
        airTemperatureTimeSeries: [TemperatureTimeSeriesEntry] = [],
        rainFallTimeSeries: [RainfallTimeSeriesEntry] = [],
        groundwaterLevelTimeSeries: [WaterLevelTimeSeriesEntry] = [],
        groundwaterTemperatureTimeSeries: [TemperatureTimeSeriesEntry] = [],
        surfaceWaterLevelTimeSeries: [WaterLevelTimeSeriesEntry] = [],
        surfaceWaterTemperatureTimeSeries: [TemperatureTimeSeriesEntry] = []
    ) {
        self.number = number
        self.name = name
        self.water = water
        self.timeZone = timeZone
        self.airTemperatureTimeSeries = airTemperatureTimeSeries
        self.rainfallTimeSeries = rainFallTimeSeries
        self.groundwaterLevelTimeSeries = groundwaterLevelTimeSeries
        self.groundwaterTemperatureTimeSeries = groundwaterTemperatureTimeSeries
        self.surfaceWaterLevelTimeSeries = surfaceWaterLevelTimeSeries
        self.surfaceWaterTemperatureTimeSeries = surfaceWaterTemperatureTimeSeries
    }
}
