//
//  WorkoutView.swift
//  FitBodChallenge_RobBooth
//
//  Created by Rob Booth on 6/2/24.
//

import SwiftUI

struct WorkoutView: View {
    var viewModel: WorkoutViewModel
    
    @State var selectedDate: Date?
    
    var body: some View {
        VStack {
            OneRepChartView(viewModel: viewModel.oneRepChartViewModel, selectedDate: $selectedDate)
            
            Text("All Data")
            
            WorkoutsGridView(viewModel: viewModel.workoutGridViewModel, selectedDate: $selectedDate)
        }
        .navigationTitle(viewModel.title)
    }
}

#Preview {
    WorkoutView(viewModel: WorkoutViewModel(workoutType: .barbellBenchPress, workouts: [
        Workout(date: DateFormatter.workoutDateFormatter.date(from:"Oct 05 2020") ?? .now, type: .barbellBenchPress, reps: 4, weight: 45),
        Workout(date: DateFormatter.workoutDateFormatter.date(from:"Oct 05 2020") ?? .now, type: .barbellBenchPress, reps: 4, weight: 125),
        Workout(date: DateFormatter.workoutDateFormatter.date(from:"Sep 28 2020") ?? .now, type: .barbellBenchPress, reps: 10, weight: 45),
        Workout(date: DateFormatter.workoutDateFormatter.date(from:"Sep 28 2020") ?? .now, type: .barbellBenchPress, reps: 8, weight: 135)
    ])
    )
}
