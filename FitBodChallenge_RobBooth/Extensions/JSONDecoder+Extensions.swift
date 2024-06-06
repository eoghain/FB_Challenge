//
//  JSONDecoder+Extensions.swift
//  FitBodChallenge_RobBooth
//
//  Created by Rob Booth on 6/2/24.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
  static func anyFormatter(in formatters: [DateFormatter]) -> Self {
    return .custom { decoder in
      guard formatters.count > 0 else {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "No date formatter provided"))
      }
      
      guard let dateString = try? decoder.singleValueContainer().decode(String.self) else {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not decode date string"))
      }
      
      let successfullyFormattedDates = formatters.lazy.compactMap { $0.date(from: dateString) }
      guard let date = successfullyFormattedDates.first else {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Date string \"\(dateString)\" does not match any of the expected formats (\(formatters.compactMap(\.dateFormat).joined(separator: " or ")))"))
      }
      
      return date
    }
  }
}
