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
            
            let x = -2.0 + Double(i)
            
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
    
    
    let step = 0.01
    
    
    
    
    
    
    
    func calculateValuesFromMu(_ mu: Double, _ xArray: inout [Double], _ plotData: inout [(x: Double, y: Double)]) {
        for n in 1 ..< 600 {
            
            //create x values here
            let x = mu * xArray[n-1] * (1-xArray[n-1])
            xArray.append(x)
            let dataPoint: (x: Double, y: Double) = (x: Double(n), y: x)
            plotData.append(contentsOf: [dataPoint])
            theText += "x = \(n), y = \(x)\n"
        }
    }
    
    
    func calculateOneCycle(mu: Double) async
    {
        
        
        
        await resetCalculatedTextOnMainThread()
        
        var xArray: [Double] = []
        xArray.append(0.75)
        
        
        
        theText = "y = One-Cycle\n"
        
        var plotData :[(x: Double, y: Double)] =  []
        let dataPoint: (x: Double, y: Double) = (x: 0, y: xArray[0])
        plotData.append(contentsOf: [dataPoint])
        theText += "x = \(0), y = \(xArray[0])\n"
        
        
        calculateValuesFromMu(mu, &xArray, &plotData)
        
        //set the Plot Parameters
        await setThePlotParameters(color: "Blue", xLabel: "x", yLabel: "y = One-Cycle", title: "One-Cycle", xMin: -1.0, xMax: 600.0, yMin: -0.1, yMax: 1.1)
        
        await appendDataToPlot(plotData: plotData)
        await updateCalculatedTextOnMainThread(theText: theText)
        
        return
    }
    
    
    
    
    
    
    func bifurcationCaclulation(muMin: Double, muMax: Double, step: Double) async
    {
        
        await resetCalculatedTextOnMainThread()
        
        var xArray: [Double] = []
        xArray.append(0.75)
        
        theText = "Bifurcation"
        let isTheSame = 0.005
        
        
        var plotData :[(x: Double, y: Double)] =  []
        var muPop: [(mu: Double, population: [Double])] = []
        
        
        var population: [Double] = []
        
        
        for mu in stride(from: muMin, to: muMax, by: step) {
            
            xArray.removeAll()
            plotData.removeAll()
            population.removeAll()
            xArray.append(0.75)
            
            
            calculateValuesFromMu(mu, &xArray, &plotData)
            let count = xArray.count
            
            population.append(xArray[count-100])
            
            var  populationCount = population.count
            //print(populationCount)
            var j = 0
            
            for i in (count-99)..<count{
                
                j = 0
                var isInPopulationArray = false
                
                while (j < populationCount){
                    
                    
                    let currentXArrayValue = xArray[i]
                    
                    
                    let test = abs(currentXArrayValue - population[j])
                    
                    if ((test > isTheSame && !isInPopulationArray) ) {
                        
                        isInPopulationArray = false
                        
                        
                    }
                    else{
                        
                        
                        isInPopulationArray = true
                        
                    }
                    
                    j += 1
                }
                
                if !isInPopulationArray {
                    
                    population.append(xArray[i])
                    populationCount += 1
                    
                }
                
                
                
            }
            //            print(mu)
            //           print(population)
            
            let  muStorage = (mu: mu, population: population)
            muPop.append(muStorage)
            
            
        }
        
        
        plotData.removeAll()
        theText = ""
        for item in muPop {
            
            for range in item.population{
                
                theText = "mu = \(item.mu), y = \(range)\n"
                let dataPoint: (x: Double, y: Double) = (x: Double(item.mu), y: range)
                plotData.append(contentsOf: [dataPoint])
            }
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        await setThePlotParameters(color: "Blue", xLabel: "x", yLabel: "y = Bifurcation", title: "Bifurcation", xMin: 2.9, xMax: 4.0, yMin: -0.1, yMax: 1.1)
        
        await appendDataToPlot(plotData: plotData)
        await updateCalculatedTextOnMainThread(theText: theText)
        
        return
        
        
        
    }
    
    func equation(theta: Double, dtheta: Double, w: Double) -> Double {
        // solve Eqn 12.33 using the rk4 method
        // Eqn 12.33 --> (dtheta^2 / dt^2) = -(w ^ 2)*sin(theta)
        // w is the natural frequency of the system arising from the restoring torque
        
        return(dtheta + pow(w,2)*sin(theta))
        
    }
    
    
    //Here I will define a function that uses Eulers method to find a solution to the pendulum
    
    
    
    
        
        
        
        
        
        
        
        
        // Initial conditions for the dependent variable and its derivative
        //  let theta0 = 1.0
        // let dtheta0 = 0.0
        
        //Define the step size for the RK4 method. This is the increment by which we will move forward in the independent variable x for each iteration of the RK4 method.
        
        // let h = 0.1
        
        //  func solveRK4(equation: (Double, Double, Double) -> Double, theta0: Double, dtheta0: Double, w0: Double, h: Double, n: Int) -> [Double] {
        //     var theta = [Double](repeating: 0.0, count: n)
        //    var dtheta = [Double](repeating: 0.0, count: n)
        //    var w = [Double](repeating: 0.0, count: n)
        
        //    theta[0] = theta0
        //    dtheta[0] = dtheta0
        //    w[0] = w0
        
        //    for i in 0..<n-1 {
        //       let k1 = h * dtheta[i]
        //       let l1 = h * equation(theta[i], dtheta[i], w[i])
        
        //       let k2 = h * (dtheta[i] + l1/2)
        //      let l2 = h * equation(theta[i] + k1/2, dtheta[i] + l1/2, w[i] + h/2)
        
        //      let k3 = h * (dtheta[i] + l2/2)
        //      let l3 = h * equation(theta[i] + k2/2, dtheta[i] + l2/2, w[i] + h/2)
        
        //     let k4 = h * (dtheta[i] + l3)
        //     let l4 = h * equation(theta[i] + k3, dtheta[i] + l3, w[i] + h)
        
        //      dtheta[i+1] = dtheta[i] + (1/6) * (l1 + 2*l2 + 2*l3 + l4)
        //      theta[i+1] = theta[i] + (1/6) * (k1 + 2*k2 + 2*k3 + k4)
        //     w[i+1] = w[i] + h
        //   }
        // print theta
        //   return theta
        //   }
        
        
        // func eulerMethod(theta0: Double, omega0: Double, w: Double, dt: Double, numSteps: Int) -> (thetas: [Double], omegas: [Double]) {
        //    var theta = theta0
        //    var omega = omega0
        
        //   var thetas = [theta]
        //   var omegas = [omega]
        
        //   for _ in 1...numSteps {
        //     let dThetaDt = omega0
        //   let dOmegaDt = -w*w*sin(theta)
        
        // theta += dThetaDt * dt
        //omega += dOmegaDt * dt
        
        // thetas.append(theta)
        //omegas.append(omega)
        
        //}
        
        // print(thetas, omegas)
        // return (thetas, omegas)
        
        
        
        
        
        
        
        @MainActor func resetCalculatedTextOnMainThread() {
            //Print Header
            plotDataModel!.calculatedText = ""
            
        }
        
        
        @MainActor func updateCalculatedTextOnMainThread(theText: String) {
            //Print Header
            plotDataModel!.calculatedText += theText
        }
        
    }

