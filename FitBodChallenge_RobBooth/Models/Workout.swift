//
//  Workout.swift
//  FitBodChallenge_RobBooth
//
//  Created by Rob Booth on 5/31/24.
//

import Foundation

typealias Workouts = [Workout]

struct Workout: Codable, Identifiable {
    let id: UUID = UUID()
    let date: Date
    let type: WorkoutType
    let reps: Int
    let weight: Float
    
    let oneRepMax: Double?
    let oneRepMaxInt: Int?
    
    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case type = "WorkoutType"
        case reps = "Reps"
        case weight = "Weight"
    }
    
    init(date: Date, type: WorkoutType, reps: Int, weight: Float) {
        self.date = date
        self.type = type
        self.reps = reps
        self.weight = weight
        
        // Calculated values
        self.oneRepMax = Workout.calculateOneRepMax(reps: reps, weight: weight)
        
        guard let oneRepMaxDouble = self.oneRepMax else {
            self.oneRepMaxInt = nil
            return
        }
        
        self.oneRepMaxInt = Int(oneRepMaxDouble)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the date string and convert it to a Date object
        let dateString = try container.decode(String.self, forKey: .date)
        
        guard let date = DateFormatter.workoutDateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .date,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }
        
        self.date = date
        
        // Decode the rest of the properties
        self.type = try container.decode(WorkoutType.self, forKey: .type)
        
        // Converting from String to Int because the CSV parser returns everything as Strings
        self.reps = try Int(container.decode(String.self, forKey: .reps)) ?? 0
        self.weight = try Float(container.decode(String.self, forKey: .weight)) ?? 0
        
        // Calculated values
        self.oneRepMax = Workout.calculateOneRepMax(reps: reps, weight: weight)
        
        guard let oneRepMaxDouble = self.oneRepMax else {
            self.oneRepMaxInt = nil
            return
        }
        
        self.oneRepMaxInt = Int(oneRepMaxDouble)
    }
    
    private static func calculateOneRepMax(reps: Int, weight: Float) -> Double? {
        guard reps > 0 && reps < 37 else {
            print("Reps should be between 1 and 36.")
            return nil
        }
        
        let oneRepMax = Double(weight) * (36.0 / (37.0 - Double(reps)))
        return oneRepMax
    }
}

extension Workout: Hashable {
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
