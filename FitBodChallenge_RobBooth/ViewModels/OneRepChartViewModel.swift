//
//  OneRepChartViewModel.swift
//  FitBodChallenge_RobBooth
//
//  Created by Rob Booth on 6/6/24.
//

import Foundation

struct OneRepChartViewModel {
    let type: WorkoutType
    let workouts: Workouts
    
    var title: String {
        type.rawValue
    }
    
    // Create OneRepChartData by getting the highest oneRepMax per date in original data
    var chartData: [OneRepChartView.Data] {
        workouts.reduce([Date:Double]()) { dict, workout in
            var dict = dict
            guard let storedOneRepMax = dict[workout.date] else {
                dict[workout.date] = workout.oneRepMax
                return dict
            }
            
            // Only store highest oneRepMax data
            dict[workout.date] = max(storedOneRepMax, (workout.oneRepMax ?? 0))
            return dict
        }.map { (key: Date, value: Double) in // Convert dictionary data into OneRepChartData
            OneRepChartView.Data(date: key, oneRepMax: value)
        }.sorted(by: { $0.date > $1.date }) // Sort by date
    }
}
