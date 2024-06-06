//
//  OneRepChartView.swift
//  FitBodChallenge_RobBooth
//
//  Created by Rob Booth on 6/4/24.
//

import SwiftUI
import Charts

struct OneRepChartView: View {
    private enum ZoomLevel: Int, CaseIterable, Identifiable {
        case week = 7
        case month = 30
        case year = 365
        
        var id: Int { self.rawValue }
        
        var title: String {
            switch self {
            case .week:
                return "Week"
            case .month:
                return "Month"
            case .year:
                return "Year"
            }
        }
    }
    
    struct Data: Hashable {
        let date: Date
        let oneRepMax: Double
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(date)
        }
        
        static func == (lhs: OneRepChartView.Data, rhs: OneRepChartView.Data) -> Bool {
            lhs.date == rhs.date
        }
    }
    
    var viewModel: OneRepChartViewModel
    
    @Binding var selectedDate: Date?
    @State private var zoomLevel: ZoomLevel = .year
    
    var body: some View {
        VStack {
            Picker("Chart Zoom", selection: $zoomLevel) {
                ForEach(ZoomLevel.allCases) { level in
                    Text(level.title).tag(level)
                }
            }
            .pickerStyle(.segmented)
            
            Chart {
                ForEach(viewModel.chartData, id: \.self) { data in
                    LineMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value("OneRepMax", data.oneRepMax)
                    )
                    .foregroundStyle(Color.blue)
                    .symbol {
                        Circle()
                            .fill(isDateSelected(data.date) ? Color.green : Color.blue)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { nthGeoItem in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .onTapGesture { location in
                            if let plotFrame = proxy.plotFrame {
                                let plotX = nthGeoItem[plotFrame].origin.x
                                let chartX = location.x - plotX
                                if let date = proxy.value(atX: chartX, as: Date.self) {
                                    selectedDate = date
                                }
                            }
                        }
                }
            }
            .chartScrollableAxes(.horizontal)
            .chartScrollTargetBehavior(
                .valueAligned(
                    matching: DateComponents(day: 0),
                    majorAlignment: .matching(DateComponents(month: 0))
                )
            )
            .chartXVisibleDomain(length: 86400*zoomLevel.rawValue)
            .padding()
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
    
    return OneRepChartView(viewModel: OneRepChartViewModel(type: .barbellBenchPress, workouts: [
        Workout(date: DateFormatter.workoutDateFormatter.date(from:"Oct 05 2020") ?? .now, type: .barbellBenchPress, reps: 4, weight: 45),
        Workout(date: DateFormatter.workoutDateFormatter.date(from:"Oct 05 2020") ?? .now, type: .barbellBenchPress, reps: 4, weight: 125),
        Workout(date: DateFormatter.workoutDateFormatter.date(from:"Sep 28 2020") ?? .now, type: .barbellBenchPress, reps: 10, weight: 45),
        Workout(date: DateFormatter.workoutDateFormatter.date(from:"Sep 28 2020") ?? .now, type: .barbellBenchPress, reps: 8, weight: 135),
        Workout(date: DateFormatter.workoutDateFormatter.date(from:"Sep 20 2020") ?? .now, type: .barbellBenchPress, reps: 10, weight: 45),
        Workout(date: DateFormatter.workoutDateFormatter.date(from:"Sep 20 2020") ?? .now, type: .barbellBenchPress, reps: 8, weight: 135),
        Workout(date: DateFormatter.workoutDateFormatter.date(from:"Sep 13 2020") ?? .now, type: .barbellBenchPress, reps: 6, weight: 45),
        Workout(date: DateFormatter.workoutDateFormatter.date(from:"Sep 13 2020") ?? .now, type: .barbellBenchPress, reps: 6, weight: 125)
    ]), selectedDate: $selectedDate)
}
