//
//  ContentView.swift
//  WeSplit
//
//  Created by AA on 21/2/2024.
//

import SwiftUI

struct ContentView: View {
    let items = 2..<100
    
    @State private var count: Int = 0;
    @State private var name: String = "";
    @State private var picked: Int = 2;
    @State private var amount: Double = 0.0;
    @State private var tips: Int = 0;
    @FocusState private var isFocused: Bool;
    
    var totalPerPerson: Double {
        return amount * (1.0 + Double(tips) / 100.0) / Double(picked)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Enter bs", text: $name)
                    Text("Hello, \(name) \(picked)!")
                }
                
                Section {
                    TextField("Enter amount: ", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "HKD"))
                        .keyboardType(.decimalPad)
                        .focused($isFocused)
                }
                
                Section {
                    Button("Tapped: \(count)") {
                        count += 1
                    }
                }
                
                Section {
                    Picker("Number of person", selection: $picked) {
                        ForEach(items, id: \.self) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section("How much tips?") {
                    Picker("Tips", selection: $tips) {
                        ForEach([0, 5, 10, 20], id: \.self) {
                            Text("\($0)%")
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Total per person") {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "HKD"))
                }
            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if isFocused {
                    Button("Done") {
                        isFocused = false;
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
