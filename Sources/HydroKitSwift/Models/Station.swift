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
    public var water: String?

    public var id: String { number }

    public var airTemperatureTimeSeries: [TemperatureTimeSeriesEntry]
    public var rainfallTimeSeries: [RainfallTimeSeriesEntry]
    public var groundwaterLevelTimeSeries: [WaterLevelTimeSeriesEntry]
    public var groundwaterTemperatureTimeSeries: [TemperatureTimeSeriesEntry]
    public var surfaceWaterLevelTimeSeries: [WaterLevelTimeSeriesEntry]
    public var surfaceWaterTemperatureTimeSeries: [TemperatureTimeSeriesEntry]

    public init(
        number: String,
        name: String,
        water: String? = nil,
        airTemperatureTimeSeries: [TemperatureTimeSeriesEntry] = [],
        rainFallTimeSeries: [RainfallTimeSeriesEntry] = [],
        groundwaterLevelTimeSeries: [WaterLevelTimeSeriesEntry] = [],
        groundwaterTemperatureTimeSeries: [TemperatureTimeSeriesEntry] = [],
        surfaceWaterLevelTimeSeries: [WaterLevelTimeSeriesEntry] = [],
        surfaceWaterTemperatureTimeSeries: [TemperatureTimeSeriesEntry] = [],
    ) {
        self.number = number
        self.name = name
        self.water = water
        self.airTemperatureTimeSeries = airTemperatureTimeSeries
        self.rainfallTimeSeries = rainFallTimeSeries
        self.groundwaterLevelTimeSeries = groundwaterLevelTimeSeries
        self.groundwaterTemperatureTimeSeries = groundwaterTemperatureTimeSeries
        self.surfaceWaterLevelTimeSeries = surfaceWaterLevelTimeSeries
        self.surfaceWaterTemperatureTimeSeries = surfaceWaterTemperatureTimeSeries
    }
}
