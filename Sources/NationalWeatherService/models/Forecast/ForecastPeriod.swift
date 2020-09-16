//
//  ForecastPeriod.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/2/20.
//

import Foundation

extension Forecast {
    public struct Period: Codable {
        public enum CodingKeys: String, CodingKey {
            case name, startTime, endTime, isDaytime
            case temperature, temperatureUnit, windSpeed, windDirection
            case icon, shortForecast, detailedForecast
            case temperatureValue, windSpeedValue, temperatureUnitRaw
        }

        public let name: String?

        public let startTime : Date
        public let endTime : Date
        public let date: DateInterval

        public let isDaytime: Bool

        public let temperatureValue : Double
        public let temperatureUnitRaw : String
        public let temperature: Measurement<UnitTemperature>

        public let windSpeed: Wind
        public let windSpeedValue : String
        public let windDirection : String

        public let conditions: [Condition]
        public let icon: URL
        public let shortForecast: String
        public let detailedForecast: String?

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.name = try container.decodeIfPresent(String.self, forKey: .name)

            self.startTime = try container.decode(Date.self, forKey: .startTime)
            self.endTime = try container.decode(Date.self, forKey: .endTime)

            self.date = DateInterval(start: startTime, end: endTime)
            self.isDaytime = try container.decode(Bool.self, forKey: .isDaytime)

            self.temperatureValue = try container.decode(Double.self, forKey: .temperature)
            self.temperatureUnitRaw = try container.decode(String.self, forKey: .temperatureUnit).lowercased()
            let temperatureUnit: UnitTemperature = temperatureUnitRaw == "f" ? .fahrenheit : .celsius

            self.temperature = Measurement(value: temperatureValue, unit: temperatureUnit)

            self.windSpeedValue = try container.decode(String.self, forKey: .windSpeed)
            self.windDirection = try container.decodeIfPresent(String.self, forKey: .windDirection) ?? ""
            self.windSpeed = try Wind(from: windSpeedValue, direction: windDirection)

            self.icon = try container.decode(URL.self, forKey: .icon)
            self.conditions = Condition.parseFrom(nwsAPIIconURL: self.icon)

            self.shortForecast = try container.decode(String.self, forKey: .shortForecast)
            self.detailedForecast = try container.decode(String.self, forKey: .detailedForecast)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            
            try container.encode(startTime, forKey: .startTime)
            try container.encode(endTime, forKey: .endTime)
            
            try container.encode(isDaytime, forKey: .isDaytime)
            try container.encode(temperatureValue, forKey: .temperature)
            
            try container.encode(temperatureUnitRaw, forKey: .temperatureUnit)

            try container.encode(windSpeedValue, forKey: .windSpeed)
            try container.encode(windDirection, forKey: .windDirection)

            try container.encode(icon, forKey: .icon)
            try container.encode(shortForecast, forKey: .shortForecast)
            try container.encode(detailedForecast, forKey: .detailedForecast)
        }
    }
}
