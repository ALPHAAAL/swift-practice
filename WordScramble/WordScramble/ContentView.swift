//
//  ContentView.swift
//  WordScramble
//
//  Created by AA on 15/3/2024.
//

import SwiftUI

func checkSpelling(word: String) -> Bool {
    if (word.count == 0) {
        return true
    }
    
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelled = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    
    return misspelled.location == NSNotFound
}

struct ContentView: View {
    @State private var rootWord: String = "Word"
    @State private var word: String = ""
    @State private var usedWords: [String] = []
    @State private var wrongSpelling: Bool = false;
    @State private var characterMap: Dictionary<Character, Int> = [:];
    @State private var showError: Bool = false;
    @State private var errorMessage: String = "";
    
    func validateWord(_ word: String) -> Bool {
        var temp = characterMap;
        var hasError = false
        
        word.forEach { c in
            if temp[c] == nil || temp[c] == 0 {
                hasError = true
                
                return
            }
            
            temp[c]! -= 1
        }
        
        return !hasError
    }
    
    func addWord() {
        let answer = word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if answer.count < 0 {
            return
        }
        
        if wrongSpelling {
            showError = true
            errorMessage = "Word doesn't exist"
            
            return
        }
        
        if usedWords.contains(answer) {
            showError = true
            errorMessage = "Word used"
            
            return
        }
        
        if !validateWord(answer) {
            showError = true
            errorMessage = "You cannot spell this word with the characters in \(rootWord)"
            
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        word = ""
    }
    
    func startGame() {
        if let fileUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let words = try? String(contentsOf: fileUrl) {
                let allWords = words.components(separatedBy: "\n")
                var map: Dictionary<Character, Int> = [:]
                rootWord = allWords.randomElement() ?? "silkworm"
                
                rootWord.forEach { c in
                    if map[c] != nil {
                        map[c]! += 1
                    } else {
                        map[c] = 1
                    }
                }
                
                characterMap = map
                
                return
            }
        }
        
        fatalError("Failed to init the file")
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Enter your word") {
                    let binding = Binding<String>(get: {
                        word
                    }, set: {
                        word = $0
                        
                        if (!checkSpelling(word: $0)) {
                            wrongSpelling = true
                        } else {
                            wrongSpelling = false
                        }
                    })
                    
                    TextField("Enter a word", text: binding)
                        .textInputAutocapitalization(.never)
                        .onAppear(perform: startGame)
                        .onSubmit(addWord)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 0.0)
                                .stroke(wrongSpelling ? Color.red : Color.black)
                        );
                }
                
                Section("Used words") {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
                
                Button("Restart!") {
                    startGame()
                }
            }
                .navigationTitle(rootWord)
        }
            .alert("Wrong!", isPresented: $showError) {} message: {
                Text(errorMessage)
            }
            .padding()
    }
}

#Preview {
    ContentView()
}
