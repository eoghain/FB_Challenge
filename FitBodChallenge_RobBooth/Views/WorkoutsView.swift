//
//  WorkoutsView.swift
//  FitBodChallenge_RobBooth
//
//  Created by Rob Booth on 5/31/24.
//

import SwiftUI

struct WorkoutsView: View {
    @ObservedObject var viewModel: WorkoutsViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // Loading
                viewModel.state.isLoading() {
                    Group  {
                        Spacer()
                        ProgressView() {
                            Text("Loading...")
                        }
                        Spacer()
                    }
                }
                
                // Error
                viewModel.state.hasError() { error in
                    Text("Error: \(error.localizedDescription)")
                }
                
                // Workouts
                viewModel.state.hasData() {
                    List(viewModel.workoutTypes) { type in
                        NavigationLink(value: type) {
                            WorkoutsRowView(viewModel: viewModel.workoutRowViewModel(for: type))
                        }
                    }
                }
            }
            .onAppear(perform: viewModel.onAppear)
            .navigationDestination(for: WorkoutType.self, destination: { type in
                WorkoutView(viewModel: viewModel.workoutViewModel(for: type))
            })
            .navigationTitle("Workouts")
        }
    }
}

#Preview {
    WorkoutsView(viewModel: WorkoutsViewModel([
        Workout(date: DateFormatter.workoutDateFormatter.date(from: "Oct 11 2020") ?? .now, type: .backSquat, reps: 10, weight: 45),
        Workout(date: DateFormatter.workoutDateFormatter.date(from: "Oct 11 2020") ?? .now, type: .backSquat, reps: 10, weight: 135),
        Workout(date: DateFormatter.workoutDateFormatter.date(from: "Oct 14 2020") ?? .now, type: .backSquat, reps: 10, weight: 45),
        Workout(date: DateFormatter.workoutDateFormatter.date(from: "Oct 14 2020") ?? .now, type: .backSquat, reps: 8, weight: 11),
        Workout(date: DateFormatter.workoutDateFormatter.date(from: "Oct 05 2020") ?? .now, type: .barbellBenchPress, reps: 4, weight: 45),
        Workout(date: DateFormatter.workoutDateFormatter.date(from: "Oct 05 2020") ?? .now, type: .barbellBenchPress, reps: 4, weight: 125),
        Workout(date: DateFormatter.workoutDateFormatter.date(from: "Sep 28 2020") ?? .now, type: .barbellBenchPress, reps: 10, weight: 45),
        Workout(date: DateFormatter.workoutDateFormatter.date(from: "Sep 28 2020") ?? .now, type: .barbellBenchPress, reps: 8, weight: 135),
        Workout(date: DateFormatter.workoutDateFormatter.date(from: "Sep 26 2020") ?? .now, type: .deadlift, reps: 6, weight: 45),
        Workout(date: DateFormatter.workoutDateFormatter.date(from: "Sep 26 2020") ?? .now, type: .deadlift, reps: 3, weight: 225),
        Workout(date: DateFormatter.workoutDateFormatter.date(from: "Sep 14 2020") ?? .now, type: .deadlift, reps: 10, weight: 45),
        Workout(date: DateFormatter.workoutDateFormatter.date(from: "Sep 14 2020") ?? .now, type: .deadlift, reps: 10, weight: 135)
    ])
    )
}
