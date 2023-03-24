//
//  CalculatePlotData.swift
//  Test Plot Threaded Charts
//
//  Created by Jeff Terry on 8/25/22.
//

import Foundation
import SwiftUI


class CalculatePlotData: ObservableObject {
    
    var plotDataModel: PlotDataClass? = nil
    var theText = ""
    

    @MainActor func setThePlotParameters(color: String, xLabel: String, yLabel: String, title: String, xMin: Double, xMax: Double, yMin:Double, yMax:Double) {
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = yMax
        plotDataModel!.changingPlotParameters.yMin = yMin
        plotDataModel!.changingPlotParameters.xMax = xMax
        plotDataModel!.changingPlotParameters.xMin = xMin
        plotDataModel!.changingPlotParameters.xLabel = xLabel
        plotDataModel!.changingPlotParameters.yLabel = yLabel
        
        if color == "Red"{
            plotDataModel!.changingPlotParameters.lineColor = Color.red
        }
        else{
            
            plotDataModel!.changingPlotParameters.lineColor = Color.blue
        }
        plotDataModel!.changingPlotParameters.title = title
        
        plotDataModel!.zeroData()
    }
    
    @MainActor func appendDataToPlot(plotData: [(x: Double, y: Double)]) {
        plotDataModel!.appendData(dataPoint: plotData)
    }
    
    func plotYEqualsX() async
    {
        
        theText = "y = x\n"
        
        await resetCalculatedTextOnMainThread()
        
        
        var plotData :[(x: Double, y: Double)] =  []
        
        
        for i in 0 ..< 40 {
             
            //create x values here
            let x = -2.0 + Double(i) * 0.6

        //create y values here
        let y = x


            let dataPoint: (x: Double, y: Double) = (x: x, y: y)
            plotData.append(contentsOf: [dataPoint])
            theText += "x = \(x), y = \(y)\n"
        
        }
        
        await setThePlotParameters(color: "Red", xLabel: "x", yLabel: "y", title: "y = x", xMin: -4.0, xMax: 24.0, yMin: -4.0, yMax: 24.0)
        
        await appendDataToPlot(plotData: plotData)
        await updateCalculatedTextOnMainThread(theText: theText)
        
        
    }
    
    
    func ploteToTheMinusX() async
    {
        
        
        
        await resetCalculatedTextOnMainThread()
        
        theText = "y = exp(-x)\n"
        
        var plotData :[(x: Double, y: Double)] =  []
        for i in 0 ..< 60 {

            //create x values here
            let x = -2.0 + Double(i) * 0.2

        //create y values here
        let y = exp(-x)
            
            let dataPoint: (x: Double, y: Double) = (x: x, y: y)
            plotData.append(contentsOf: [dataPoint])
            theText += "x = \(x), y = \(y)\n"
        }
        
        //set the Plot Parameters
        await setThePlotParameters(color: "Blue", xLabel: "x", yLabel: "y = exp(-x)", title: "y = exp(-x)", xMin: -4.0, xMax: 12.0, yMin: -1.0, yMax: 8)
        
        await appendDataToPlot(plotData: plotData)
        await updateCalculatedTextOnMainThread(theText: theText)
        
        return
    }
    
    
        @MainActor func resetCalculatedTextOnMainThread() {
            //Print Header
            plotDataModel!.calculatedText = ""
    
        }
    
    
        @MainActor func updateCalculatedTextOnMainThread(theText: String) {
            //Print Header
            plotDataModel!.calculatedText += theText
        }
    
}
