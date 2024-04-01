//
//  ContentView.swift
//  RockPaperScissor
//
//  Created by AA on 7/3/2024.
//

import SwiftUI

let choices = ["Rock", "Paper", "Scissor"];
let winning = ["Paper", "Scissor", "Rock"];
let map = [
    "Rock": "👊🏻",
    "Paper": "🤚🏻",
    "Scissor": "✌🏻",
]

struct EmojiText: View {
    let choice: String;
    
    var body: some View {
        Text(map[choice]!)
            .font(.system(size: 100.0))
    }
}

struct EmojiButton: View {
    let choice: String;
    var handler: () -> Void;
    
    var body: some View {
        Button(action: {
            handler()
        }) {
            EmojiText(choice: choice)
        }
    }
}

struct ContentView: View {
    @State var score: Int = 0;
    @State var choice: Int = Int.random(in: 0...2);
    @State var shouldWin: Bool = Bool.random();
    
    func next() {
        choice = Int.random(in: 0...2)
        shouldWin = Bool.random()
    }
    
    var body: some View {
        VStack {
            Text("Score: \(score)")
                .font(.system(size: 72))
                .fontWeight(.bold)
            
            Spacer()
            
            Text(shouldWin ? "Beat this!" : "Gotta Lose")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(shouldWin ? .green : .red)
            
            EmojiText(choice: choices[choice])
            
            HStack {
                ForEach(choices, id: \.self) { value in
                    EmojiButton(choice: value) {
                        if (shouldWin && winning[choice] == value) {
                            score += 1
                        } else if (!shouldWin && winning[choice] != value) {
                            score += 1
                        } else {
                            score -= 1
                        }
                        
                        next()
                    }
                }
            }
            .frame(height: 200)
            .background(.red)
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
