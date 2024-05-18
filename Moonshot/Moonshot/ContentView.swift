//
//  ContentView.swift
//  Moonshot
//
//  Created by AA on 10/5/2024.
//

import SwiftUI

let columns = [
    GridItem(.adaptive(minimum: 150))
]

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(missions) { mission in
                        NavigationLink {
                            MissionView(mission: mission, astronauts: astronauts)
                        } label: {
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                
                                VStack {
                                    Text(mission.displayName)
                                        .foregroundStyle(.white)
                                        .font(.headline)
                                    Text(mission.formattedLaunchDate)
                                        .foregroundStyle(.white.opacity(0.5))
                                        .font(.caption)
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackground)
                            }
                            .clipShape(.rect(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.lightBackground)
                            )
                        }
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Moonshot")
            .background(.darkBackground)
        }
    }
}

#Preview {
    ContentView()
}
