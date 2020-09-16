//
//  Point.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/2/20.
//

import Foundation

public struct Point: Codable {
    public enum CodingKeys: String, CodingKey {
        case cwa, gridX, gridY, forecast, forecastHourly, relativeLocation, timeZone, radarStation
    }
    public let cwa: String
    public let gridX: Int
    public let gridY: Int

    public let forecast: URL
    public let forecastHourly: URL

//    public let relativeLocation: MKGeoJSONFeature
    
    public let timeZone: String
    public let radarStation: String

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.cwa = try container.decode(String.self, forKey: .cwa)
        self.gridX = try container.decode(Int.self, forKey: .gridX)
        self.gridY = try container.decode(Int.self, forKey: .gridY)
        self.forecast = try container.decode(URL.self, forKey: .forecast)
        self.forecastHourly = try container.decode(URL.self, forKey: .forecastHourly)
        self.timeZone = try container.decode(String.self, forKey: .timeZone)
        self.radarStation = try container.decode(String.self, forKey: .radarStation)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cwa, forKey: .cwa)
        try container.encode(gridX, forKey: .gridX)
        try container.encode(gridY, forKey: .gridY)
        try container.encode(forecast, forKey: .forecast)
        try container.encode(forecastHourly, forKey: .forecastHourly)
        try container.encode(timeZone, forKey: .timeZone)
        try container.encode(radarStation, forKey: .radarStation)
    }
}
