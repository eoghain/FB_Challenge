//
//  WorkoutTests.swift
//  FitBodChallenge_RobBoothTests
//
//  Created by Rob Booth on 6/2/24.
//

import XCTest
@testable import FitBodChallenge_RobBooth

final class WorkoutTests: XCTestCase {
    
    // Test case for typical valid inputs
    func testCalculateOneRepMaxWithValidInputs() {
        let workout = Workout(date: Date(), type: .barbellBenchPress, reps: 10, weight: 100)
        let expectedOneRepMax = 100.0 * (36.0 / (37.0 - 10.0))
        
        if let calculatedOneRepMax = workout.oneRepMax {
            XCTAssertEqual(calculatedOneRepMax, expectedOneRepMax, accuracy: 0.001, "Calculated one-rep max does not match the expected value")
        } else {
            XCTFail("calculateOneRepMax returned nil for valid inputs")
        }
    }
    
    // Test case for the minimum valid reps (1 rep)
    func testCalculateOneRepMaxWithMinimumReps() {
        let workout = Workout(date: Date(), type: .barbellBenchPress, reps: 1, weight: 100)
        let expectedOneRepMax = 100.0 * (36.0 / (37.0 - 1.0))
        
        if let calculatedOneRepMax = workout.oneRepMax {
            XCTAssertEqual(calculatedOneRepMax, expectedOneRepMax, accuracy: 0.001, "Calculated one-rep max does not match the expected value for minimum reps")
        } else {
            XCTFail("calculateOneRepMax returned nil for minimum valid reps")
        }
    }
    
    // Test case for the maximum valid reps (36 reps)
    func testCalculateOneRepMaxWithMaximumReps() {
        let workout = Workout(date: Date(), type: .barbellBenchPress, reps: 36, weight: 100)
        let expectedOneRepMax = 100.0 * (36.0 / (37.0 - 36.0))
        
        if let calculatedOneRepMax = workout.oneRepMax {
            XCTAssertEqual(calculatedOneRepMax, expectedOneRepMax, accuracy: 0.001, "Calculated one-rep max does not match the expected value for maximum reps")
        } else {
            XCTFail("calculateOneRepMax returned nil for maximum valid reps")
        }
    }
    
    // Test case for reps below the valid range (0 reps)
    func testCalculateOneRepMaxWithZeroReps() {
        let workout = Workout(date: Date(), type: .barbellBenchPress, reps: 0, weight: 100)
        
        let calculatedOneRepMax = workout.oneRepMax
        XCTAssertNil(calculatedOneRepMax, "calculateOneRepMax should return nil for reps below the valid range")
    }
    
    // Test case for reps above the valid range (37 reps)
    func testCalculateOneRepMaxWithExcessiveReps() {
        let workout = Workout(date: Date(), type: .barbellBenchPress, reps: 37, weight: 100)
        
        let calculatedOneRepMax = workout.oneRepMax
        XCTAssertNil(calculatedOneRepMax, "calculateOneRepMax should return nil for reps above the valid range")
    }
}

