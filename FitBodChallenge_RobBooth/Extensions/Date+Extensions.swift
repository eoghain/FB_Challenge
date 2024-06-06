//
//  Date+Extensions.swift
//  FitBodChallenge_RobBooth
//
//  Created by Rob Booth on 6/2/24.
//

import Foundation

extension DateFormatter {
    static let workoutDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
