//
//  TemperatureTimeSeriesEntry.swift
//
//
//  Created by Patrick Steiner on 04.02.24.
//

import Foundation

public struct TemperatureTimeSeriesEntry: Identifiable, Sendable {
    public let measurement: Measurement<UnitTemperature>
    public let updateDate: Date
    public let id = UUID()

    public init(value: Double, updateDate: Date) {
        self.measurement = Measurement(value: value, unit: .celsius)
        self.updateDate = updateDate
    }
}
