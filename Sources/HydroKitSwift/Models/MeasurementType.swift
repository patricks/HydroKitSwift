//
//  MeasurementType.swift
//
//
//  Created by Patrick Steiner on 04.02.24.
//

import Foundation

public enum MeasurementType: String, CaseIterable, Codable, Sendable {
    case airTemperature = "LT"  // AirTemperature
    case groundwaterLevel = "GWS"  // GroundwaterLevel
    case groundwaterTemperature = "GWT"  // GroundwaterTemperature
    case rainfall = "NI"  // Rainfall
    case surfaceWaterLevel = "OG"  // SurfaceWaterLevel
    case surfaceWaterTemperature = "WT"  // SurfaceWaterTemperature

    public var openDataURL: URL {
        let baseURL = "https://www.land-oberoesterreich.gv.at/files/ogd/hydro/"
        let filename = "HDOOE_Export_\(rawValue).zrxp"

        return URL(string: "\(baseURL)\(filename)")!
    }
}
