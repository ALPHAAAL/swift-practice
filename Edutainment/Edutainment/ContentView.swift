//
//  ContentView.swift
//  Edutainment
//
//  Created by AA on 1/4/2024.
//

import SwiftUI

struct NumberCard<Content: View>: View {
    @ViewBuilder let content: Content;
    
    var body: some View {
        VStack {
            content
        }
        .frame(width: 75, height: 100)
        .background(.red)
    }
}

struct QuestionRow: View {
    var answer: Binding<String>;
    let left: String;
    let right: String;
    
    var body: some View {
        HStack {
            NumberCard() {
                Text(left)
            }
            Text("X")
            NumberCard() {
                Text(right)
            }
            Text("=")
            NumberCard() {
                TextField("?", text: answer)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
            }
        }
        .padding(20)
        .transition(.scale)
    }
}

struct ContentView: View {
    @State private var table = 2;
    @State private var numQuestions = 5;
    @State private var answer = "";
    @State private var left = "";
    @State private var right = "";
    @State private var isStart = false
    @State private var showAlert = false
    @State private var questionAnswered = 1
    
    func generateQuestion() {
        left = String(table)
        right = String(Int.random(in: 2...12))
        answer = ""
    }
    
    var body: some View {
        VStack {
            Stepper(value: $table, in: 2...12, step: 1) {
                    Text("Multiplication table: \(table)")
            }
            Stepper(value: $numQuestions, in: 5...20, step: 5) {
                    Text("Number of questions: \(numQuestions)")
            }
            
            Button("Start!") {
                withAnimation {
                    isStart = true
                    generateQuestion()
                }
            }
            
            Divider()
            
            if isStart {
                Text("\(questionAnswered) of \(numQuestions)");
                QuestionRow(answer: $answer, left: left, right: right)
                
                Button("Next!") {
                    let leftInt = Int(left)!
                    let rightInt = Int(right)!
                    let answerInt = Int(answer) ?? 0
                    
                    if questionAnswered == numQuestions {
                        showAlert = true
                        
                        return
                    }
                    if leftInt * rightInt == answerInt {
                        generateQuestion()
                        questionAnswered += 1
                    } else {
                        showAlert = true
                    }
                }
            }
        }
        .padding()
        .alert(questionAnswered == numQuestions ? "You win!" : "Wrong answer!", isPresented: $showAlert) {
            Button("OK") {
                if questionAnswered == numQuestions {
                    isStart = false
                    questionAnswered = 1
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
