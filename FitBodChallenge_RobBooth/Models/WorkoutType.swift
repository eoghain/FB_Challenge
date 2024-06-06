//
//  WorkoutType.swift
//  FitBodChallenge_RobBooth
//
//  Created by Rob Booth on 5/31/24.
//

import Foundation

enum WorkoutType: String, Codable, Identifiable {
    var id: Self {
        return self
    }
    
    case backSquat = "Back Squat"
    case barbellBenchPress = "Barbell Bench Press"
    case deadlift = "Deadlift"
}

extension WorkoutType {
    var imageName: String {
        switch self {
        case .backSquat:
            return "backSquat"
        case .barbellBenchPress:
            return "barbellBenchPress"
        case .deadlift:
            return "deadlift"
        }
    }
}
