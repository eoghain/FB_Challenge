//
//  FitBodChallenge_RobBoothApp.swift
//  FitBodChallenge_RobBooth
//
//  Created by Rob Booth on 5/31/24.
//

import SwiftUI

@main
struct FitBodChallenge_RobBoothApp: App {    
    var body: some Scene {
        WindowGroup {
            WorkoutsView(viewModel: WorkoutsViewModel(nil))
        }
    }
}
