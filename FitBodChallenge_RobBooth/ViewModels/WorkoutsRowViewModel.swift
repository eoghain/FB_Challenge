//
//  WorkoutsRowViewModel.swift
//  FitBodChallenge_RobBooth
//
//  Created by Rob Booth on 6/6/24.
//

import Foundation

struct WorkoutsRowViewModel {
    let type: WorkoutType
    let workouts: Workouts
    
    var typeName: String {
        type.rawValue
    }
    
    var maxOneRepMax: Int {
        workouts.map({ $0.oneRepMaxInt ?? 0 }).max() ?? 0
    }
    
    var imageName: String {
        type.imageName
    }
}
