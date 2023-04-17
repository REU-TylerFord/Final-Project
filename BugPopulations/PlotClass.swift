//
//  PlotClass.swift
//  Test Plot Threaded Charts
//
//  Created by Jeff Terry on 8/25/22.
//

import Foundation

class PlotClass: ObservableObject {
    
    @Published var plotArray: [PlotDataClass]
    
    @MainActor init() {
        self.plotArray = [PlotDataClass.init(fromLine: true)]
        self.plotArray.append(contentsOf: [PlotDataClass.init(fromLine: true)])
            
        }

    
}
