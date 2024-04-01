//
//  Progress_TrackerApp.swift
//  Progress Tracker
//
//  Created by AA on 12/4/2023.
//

import SwiftUI

@main
struct Progress_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomePage()
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(true)
            }
        }
    }
}


//Brand color: #1E88E5 (a blue color)
//
//Primary color: #43A047 (a green color)
//
//Secondary color: #FFB900 (a yellow/orange color)
//
//Background color: #F5F5F5 (a light gray color)
//
//Text color: #333333 (a dark gray color)

//Pair 1:
//Header font: "Montserrat Bold" (https://fonts.google.com/specimen/Montserrat)
//
//Body font: "Roboto Regular" (https://fonts.google.com/specimen/Roboto)
//
//Pair 2:
//Header font: "Lato Black" (https://fonts.google.com/specimen/Lato)
//
//Body font: "Open Sans Regular" (https://fonts.google.com/specimen/Open+Sans)
//
//These font pairings should be easy to read and provide a good visual hierarchy for your app.
