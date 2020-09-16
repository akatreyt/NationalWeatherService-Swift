//
//  Forecast.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/2/20.
//

import Foundation

public struct Forecast: Codable {
    public enum CodingKeys: String, CodingKey {
        case updated, generatedAt, validTimes, elevation, periods, validTimesValue
    }

    public let updated: Date
    public let generatedAt: Date

    public let validTimesValue : String
    public let validTimes: DateInterval
    public let elevation: Measurement<UnitLength>
    public let periods: [Period]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.updated = try container.decode(Date.self, forKey: .updated)
        self.generatedAt = try container.decode(Date.self, forKey: .generatedAt)

        self.validTimesValue = try container.decode(String.self, forKey: .validTimes)
        guard let validTimes = DateInterval.iso8601Interval(from: self.validTimesValue) else {
            throw DecodingError.dataCorruptedError(forKey: .validTimes, in: container, debugDescription: "Invalid date interval.")
        }
        self.validTimes = validTimes

        let elevationContainer = try container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: .elevation)
        let elevationValue = try elevationContainer.decode(Double.self, forKey: AnyCodingKey(stringValue: "value"))

        self.elevation = Measurement(value: elevationValue, unit: .meters)      // NWS returns elevation in meters regardless of parent unit

        self.periods = try container.decode([Period].self, forKey: .periods)
    }

     public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(updated, forKey: .updated)
        try container.encode(generatedAt, forKey: .generatedAt)
        try container.encode(validTimesValue, forKey: .validTimes)
        try container.encode(elevation, forKey: .elevation)
        try container.encode(periods, forKey: .periods)
    }
}
