//
//  WaterLevelTimeSeriesEntry.swift
//
//
//  Created by Patrick Steiner on 05.02.24.
//

import Foundation

public struct WaterLevelTimeSeriesEntry: Identifiable, Sendable {
    public let measurement: Measurement<UnitLength>
    public let updateDate: Date
    public let id = UUID()

    public init(value: Double, updateDate: Date) {
        self.measurement = Measurement(value: value, unit: .centimeters)
        self.updateDate = updateDate
    }
}

extension WaterLevelTimeSeriesEntry: Comparable {
    public static func < (lhs: WaterLevelTimeSeriesEntry, rhs: WaterLevelTimeSeriesEntry) -> Bool {
        lhs.measurement.value < rhs.measurement.value
    }
}
