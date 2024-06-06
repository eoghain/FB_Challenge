//
//  WorkoutViewModel.swift
//  FitBodChallenge_RobBooth
//
//  Created by Rob Booth on 6/6/24.
//

import Foundation

struct WorkoutViewModel {
    var workoutType: WorkoutType
    var workouts: Workouts
    
    var title: String {
        workoutType.rawValue
    }
    
    var oneRepChartViewModel: OneRepChartViewModel {
        OneRepChartViewModel(type: workoutType, workouts: workouts)
    }
    
    var workoutGridViewModel: WorkoutGridViewModel {
        WorkoutGridViewModel(workouts: workouts)
    }
}
