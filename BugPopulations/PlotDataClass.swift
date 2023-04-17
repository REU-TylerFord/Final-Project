//
//  PlotDataClass.swift
//  Test Plot Threaded Charts
//
//  Created by Jeff Terry on 8/25/22.
//

import Foundation
import SwiftUI


class PlotDataClass: NSObject, ObservableObject {
    
    @MainActor @Published var plotData = [PlotDataStruct]()
    @MainActor @Published var changingPlotParameters: ChangingPlotParameters = ChangingPlotParameters()
    @MainActor @Published var calculatedText = ""
    //In case you want to plot vs point number
    @MainActor @Published var pointNumber = 1.0
    
    @MainActor init(fromLine line: Bool) {
        
        
        //Must call super init before initializing plot
        super.init()
       
        
        //Intitialize the first plot
        self.plotBlank()
        
       }
    
    
    
    @MainActor func plotBlank()
    {
        zeroData()
        
        //set the Plot Parameters
        changingPlotParameters.yMax = 4.0
        changingPlotParameters.yMin = -1.0
        changingPlotParameters.xMax = 4.0
        changingPlotParameters.xMin = -1.0
        changingPlotParameters.xLabel = "x"
        changingPlotParameters.yLabel = "y"
        changingPlotParameters.lineColor = Color.red
        changingPlotParameters.title = "y = x"
        
        
        
    }
    
    @MainActor func zeroData(){
            
            plotData = []
            pointNumber = 1.0
            
        }
        
    @MainActor func appendData(dataPoint: [(x: Double, y: Double)])
        {
          
            for item in dataPoint{
                
                let dataValue :[PlotDataStruct] =  [.init(xVal: item.x, yVal: item.y)]
                
                plotData.append(contentsOf: dataValue)
                pointNumber += 1.0
                
            }
            
        }
    
    

}
