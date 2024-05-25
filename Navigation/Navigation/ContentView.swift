//
//  ContentView.swift
//  Navigation
//
//  Created by AA on 25/5/2024.
//

import SwiftUI

struct DetailView: View {
    @Binding var path: PathStore
    var number: Int
    
    var body: some View {
        NavigationLink("Go to ", value: Int.random(in: 1...1000))
            .navigationTitle("Number: \(number)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.blue)
            .toolbar {
                Button("Home") {
                    path.path = NavigationPath()
                }
            }
    }
}

@Observable
class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }
    
    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")
    
    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }
        
        path = NavigationPath()
    }
    
    func save() {
        guard let representation = path.codable else { return }
        
        do {
            let data = try JSONEncoder().encode(representation)
            
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}

struct ContentView: View {
    @State private var path = PathStore()
    
    var body: some View {
        NavigationStack(path: $path.path) {
            DetailView(path: $path, number: 0)
                .navigationDestination(for: Int.self) { i in
                    DetailView(path: $path, number: i)
                }
        }
    }
}

#Preview {
    ContentView()
}
