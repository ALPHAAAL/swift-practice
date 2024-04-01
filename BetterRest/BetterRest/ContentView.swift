//
//  ContentView.swift
//  BetterRest
//
//  Created by AA on 11/3/2024.
//

import CoreML
import SwiftUI

extension Double {
    func toHourString() -> String {
        let minute = Int(self.truncatingRemainder(dividingBy: 1) * 60)
        
        return "\(Int(floor(self))) hours \(minute) \(minute > 0 ? "minutes" : "minute")"
    }
}

let defaultWakeTime: Date = Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? .now

struct ContentView: View {
    @State private var sleepAmount: Double = 1
    @State private var numCoffee: Int = 0
    @State private var wakeUpAt: Date = defaultWakeTime
    @State private var alertTitle: String = ""
    @State private var alertContent: String = ""
    @State private var showAlert: Bool = false
    
    func calculateBedtime() -> Date {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpAt)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(Double(hour + minute)), estimatedSleep: sleepAmount, coffee: Int64(numCoffee))
            
            return (wakeUpAt - prediction.actualSleep);
        } catch {
            return .now
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker(
                        "Please choose a date",
                        selection: $wakeUpAt,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                }
                
                Section("How much sleep do you want?") {
                    Stepper(
                        "Sleep amount: \(sleepAmount.toHourString())",
                        value: $sleepAmount,
                        in: 1...14,
                        step: 0.25
                    )
                }
                
                Section("How many coffee today") {
                    Stepper("^[\(numCoffee) cup](inflect: true)", value: $numCoffee, in: 0...10)
                }
                
                Text("Predicted Sleep Time: \(calculateBedtime().formatted(date: .omitted, time: .shortened))")
            }
            .navigationTitle("BetterRest")
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
