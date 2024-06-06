//
//  WorkoutsGridView.swift
//  FitBodChallenge_RobBooth
//
//  Created by Rob Booth on 6/2/24.
//

import SwiftUI

struct WorkoutsGridView: View {
    var viewModel: WorkoutGridViewModel
    
    @Binding var selectedDate: Date?
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.fixed(70)),
        GridItem(.fixed(70)),
        GridItem(.fixed(70)),
        GridItem(.fixed(70))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                // Headers
                Group {
                    Text("Date:")
                    Text("Reps:")
                    Text("Weight:")
                    Text("1RM")
                    Text("")
                }
                
                // Dividers
                Divider()
                Divider()
                Divider()
                Divider()
                Divider()
                    .hidden() // hide 5th divider for button as it has no header
                
                // Rows
                ForEach(viewModel.workouts) { workout in
                    Text(workout.date.formatted(date: .abbreviated, time: .omitted))
                        .background(isDateSelected(workout.date) ? Color.gray : Color.clear )
                    Text("\(workout.reps)")
                        .background(isDateSelected(workout.date) ? Color.gray : Color.clear )
                    Text("\(workout.weight, specifier: "%.2f")")
                        .background(isDateSelected(workout.date) ? Color.gray : Color.clear )
                    Text("\(workout.oneRepMaxInt ?? 0)")
                        .background(isDateSelected(workout.date) ? Color.gray : Color.clear )
                    Button(action: { selectedDate = workout.date }) {
                        Image(systemName: "eye")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .font(.caption)
            }
        }
    }
    
    func isDateSelected(_ date: Date) -> Bool {
        guard let selectedDate else {
            return false
        }
        
        guard Calendar.current.compare(selectedDate, to: date, toGranularity: .day) == .orderedSame else {
            return false
        }
        
        return true
    }
}

#Preview {
    @State var selectedDate: Date? = Date()
    
    return WorkoutsGridView(viewModel: WorkoutGridViewModel(workouts: [
        Workout(date: DateFormatter.workoutDateFormatter.date(from:"Oct 05 2020") ?? .now, type: .barbellBenchPress, reps: 4, weight: 45),
        Workout(date: DateFormatter.workoutDateFormatter.date(from:"Oct 05 2020") ?? .now, type: .barbellBenchPress, reps: 4, weight: 125),
        Workout(date: DateFormatter.workoutDateFormatter.date(from:"Sep 28 2020") ?? .now, type: .barbellBenchPress, reps: 10, weight: 45),
        Workout(date: DateFormatter.workoutDateFormatter.date(from:"Sep 28 2020") ?? .now, type: .barbellBenchPress, reps: 8, weight: 135)
    ]), selectedDate: $selectedDate)
}
