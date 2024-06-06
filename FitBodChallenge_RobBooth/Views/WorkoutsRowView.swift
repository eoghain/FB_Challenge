//
//  WorkoutsRowView.swift
//  FitBodChallenge_RobBooth
//
//  Created by Rob Booth on 6/2/24.
//

import SwiftUI

struct WorkoutsRowView: View {
    var viewModel: WorkoutsRowViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(viewModel.imageName)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .scaledToFill()
                
                Text(viewModel.typeName)
                
                Spacer()
                
                Text("\(viewModel.maxOneRepMax)")
            }
            .font(.headline)
            
            Text("One Rep Max ・ lbs")
                .font(.footnote)
                .foregroundStyle(.gray)
        }
        .padding()
    }
}

#Preview {
    WorkoutsRowView(viewModel: WorkoutsRowViewModel(type: .backSquat, workouts: [
        Workout(date: DateFormatter.workoutDateFormatter.date(from: "Oct 11 2020") ?? .now, type: .backSquat, reps: 10, weight: 45),
        Workout(date: DateFormatter.workoutDateFormatter.date(from: "Oct 11 2020") ?? .now, type: .backSquat, reps: 10, weight: 135),
        Workout(date: DateFormatter.workoutDateFormatter.date(from: "Oct 14 2020") ?? .now, type: .backSquat, reps: 10, weight: 45),
        Workout(date: DateFormatter.workoutDateFormatter.date(from: "Oct 14 2020") ?? .now, type: .backSquat, reps: 8, weight: 11)
        ]))
}
