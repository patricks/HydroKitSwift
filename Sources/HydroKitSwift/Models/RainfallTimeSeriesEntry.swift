//
//  RainfallTimeSeriesEntry.swift
//
//
//  Created by Patrick Steiner on 05.02.24.
//

import Foundation

public struct RainfallTimeSeriesEntry: Identifiable, Sendable {
    public let measurement: Measurement<UnitLength>
    public let updateDate: Date
    public let id = UUID()

    public init(value: Double, updateDate: Date) {
        self.measurement = Measurement(value: value, unit: .millimeters)
        self.updateDate = updateDate
    }
}
