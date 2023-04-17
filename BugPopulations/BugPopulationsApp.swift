//
//  BugPopulationsApp.swift
//  Test Plot Threaded Charts
//
//  Created by Jeff Terry on 8/25/22.
//

import SwiftUI

@main
struct BugPopulationsApp: App {
    
    @StateObject var plotData = PlotClass()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .environmentObject(plotData)
                    .tabItem {
                        Text("Plot")
                    }
                TextView()
                    .environmentObject(plotData)
                    .tabItem {
                        Text("Text")
                    }
                            
                            
            }
            
        }
    }
}
