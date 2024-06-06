//
//  WorkoutsViewModel.swift
//  FitBodChallenge_RobBooth
//
//  Created by Rob Booth on 6/6/24.
//

import SwiftUI

class WorkoutsViewModel: ObservableObject {
    enum State {
        case loading
        case error(Error)
        case success
        
        var loading: Bool {
            if case .loading = self {
                return true
            }
            
            return false
        }
        
        var error: Error? {
            switch self {
            case .error(let error):
                return error
            default:
                return nil
            }
        }
                
        func isLoading<Content: View>(@ViewBuilder content: @escaping () -> Content) -> Content? {
            switch self {
            case .loading:
                return content()
            default:
                return nil
            }
        }
        
        func hasData<Content: View>(@ViewBuilder content: @escaping () -> Content) -> Content? {
            switch self {
            case .success:
                return content()
            default:
                return nil
            }
        }
        
        func hasError<Content: View>(@ViewBuilder content: @escaping (Error) -> Content) -> Content? {
            switch self {
            case .error(let error):
                return content(error)
            default:
                return nil
            }
        }
    }
    
    @Published var workouts: Workouts?
    @Published var state: State = .loading
    
    var workoutTypes: [WorkoutType] {
        guard let workouts else { return [] }
        
        return workouts.unique(by: { $0.type }).map({ $0.type })
    }
    
    init(_ workouts: Workouts?) {
        self.workouts = workouts
    }
    
    func workouts(for type: WorkoutType) -> Workouts {
        guard let workouts, workouts.isEmpty == false else { return [] }
        
        return workouts.filter { $0.type == type }
    }
    
    func workoutViewModel(for type: WorkoutType) -> WorkoutViewModel {
        WorkoutViewModel(workoutType: type, workouts: workouts(for: type))
    }
    
    func workoutRowViewModel(for type: WorkoutType) -> WorkoutsRowViewModel {
        WorkoutsRowViewModel(type: type, workouts: workouts(for: type))
    }
    
    func onAppear() {
        state = .loading
        
        Task {
            let workouts = await convertCSVFileToWorkouts(fileName: "workouts", fileExtension: "csv")
            
            DispatchQueue.main.async {
                self.workouts = workouts
                self.state = .success
            }
        }
    }
    
    private func convertCSVFileToWorkouts(fileName: String, fileExtension: String) async -> Workouts {
        var workouts: Workouts = []
        
        // Load the file asynchronously
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            DispatchQueue.main.async {
                self.state = .error(CSVParsingError.fileNotFound)
            }
            return []
        }
        
        do {
            // Read file content
            var csvString = try String(contentsOf: fileURL, encoding: .utf8)
            
            // Inject headers
            csvString.insert(contentsOf: "Date,WorkoutType,Reps,Weight\n", at: csvString.startIndex)
            
            // Parse CSV content to array of dictionaries
            let parsedData = try CSVConverter.parse(csvString)
            
            // Convert parsed data to JSON
            let jsonData = try CSVConverter.convertToJSON(parsedData)
            
            // Create local objects
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .anyFormatter(in: [.workoutDateFormatter])
            workouts = try decoder.decode([Workout].self, from: jsonData)
        } catch {
            DispatchQueue.main.async {
                self.state = .error(error)
            }
        }
        
        return workouts
    }
}
