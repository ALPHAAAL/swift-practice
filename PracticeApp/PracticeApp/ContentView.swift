//
//  ContentView.swift
//  PracticeApp
//
//  Created by AA on 26/2/2024.
//

import SwiftUI

struct BigText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.blue)
            .font(.largeTitle)
            .background(.black)
    }
}

extension View {
    func bigTextStyle() -> some View {
        modifier(BigText())
    }
}

struct ContentView: View {
    @State private var temperature: Double = 36.5;
    @State private var fromUnit = UnitTemperature.celsius;
    @State private var toUnit = UnitTemperature.fahrenheit;
    
    var body: some View {
        VStack {
            Text("Hello world")
                .bigTextStyle()
        }
    }
}

#Preview {
    ContentView()
}
