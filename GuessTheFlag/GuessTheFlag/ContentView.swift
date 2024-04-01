//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by AA on 27/2/2024.
//

import SwiftUI

struct ButtonView: View {
    @State private var showAlert = false;
    
    var body: some View {
        Button {
            showAlert = true
            print("Fuck")
        } label: {
            Image(systemName: "pencil")
            Text("Hehe")
        }
        .alert("Fuck youuuuuu", isPresented: $showAlert) {
            Button("OK") {
                showAlert = false
            }
        }
        .buttonStyle(.borderedProminent)
    }
}

struct GridView: View {
    var body: some View {
        ZStack {
            Color.red
            VStack {
                ForEach(1...3, id: \.self) { x in
                    if (x > 1) {
                        Spacer()
                    }
                    VStack {
                        HStack(alignment: .top) {
                            ForEach(1...3, id: \.self) {y in
                                if (y > 1) {
                                    Spacer()
                                }
                                
                                if (((x - 1) * 3 + y) == 5) {
                                    ButtonView()
                                } else {
                                    Text("\((x - 1) * 3 + y)")
                                        .padding(30)
                                        .background(.blue.gradient)
                                }
                            }
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct FlagButton: View {
    let buttonHandler: () -> ();
    let country: Int;
    let countries: [String];
    
    var body: some View {
        Button {
            buttonHandler()
        } label: {
            Text("\(country)-\(countries[country])")
            Image(countries[country])
                .clipShape(.capsule)
                .shadow(radius: 10)
        }
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    @State private var answer = Int.random(in: 0...2)
    @State private var showAlert = false
    @State private var score = 0;
    @State private var alertTitle = "";
    @State private var rotationAmount: Double = 0;
    @State private var opacityAmount: Double = 1;
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                .ignoresSafeArea()
            VStack {
                VStack {
                    Text("Guess The Flag")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    
                    Text("Your score: \(score)")
                        .font(.title)
                }
                .padding(.bottom, 30)
                
                Spacer()
                
                if (score == 100) {
                    Button("Restart the game!") {
                        score = 0
                        countries.shuffle()
                        answer = Int.random(in: 0...2)
                    }
                } else {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.red)
                            .font(.title)
                        Text(countries[answer])
                            .foregroundStyle(.red)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    VStack {
                        ForEach(0...2, id: \.self) { country in
                            FlagButton(buttonHandler: {
                                if (country == answer) {
                                    withAnimation {
                                        rotationAmount = 360
                                    }
                                    score += 1
                                    alertTitle = "Your score is \(score)"
                                } else {
                                    alertTitle = "Wrong! This is the flag for \(countries[country])"
                                }
                                
                                withAnimation {
                                    opacityAmount = 0
                                }
                                showAlert = true
                                
                                print("\(country) \(countries[country])")
                            }, country: country, countries: countries)
                            .rotation3DEffect(
                                country == answer ? .degrees(rotationAmount) : .degrees(0),
                                axis: (x: 0.0, y: 1.0, z: 0.0)
                            )
                            .opacity(country != answer ? opacityAmount : 1)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 5))
                }
                
                Spacer()
            }
            .padding(30)
        }
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button("Next question") {
                opacityAmount = 1;
                rotationAmount = 0;
                countries.shuffle()
                answer = Int.random(in: 0...2)
            }
        })
    }
}

#Preview {
    ContentView()
}
