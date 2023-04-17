//
//  ContentView.swift
//  Test Plot Threaded Charts
//
//  Created by Jeff Terry on 8/25/22.
//

import SwiftUI

import SwiftUI
import Charts

struct ContentView: View {
    @EnvironmentObject var plotData :PlotClass
    
    @StateObject private var calculator = CalculatePlotData()
    @State var isChecked:Bool = false
    @State var muInput = "2.0"
    
    @State var selector = 0

    var body: some View {
        
        VStack{
            
            Group{
                
                HStack(alignment: .center, spacing: 0) {
                    
                    Text($plotData.plotArray[selector].changingPlotParameters.yLabel.wrappedValue)
                        .rotationEffect(Angle(degrees: -90))
                        .foregroundColor(.red)
                        .padding()
                    VStack {
                        Chart($plotData.plotArray[selector].plotData.wrappedValue) {
                            LineMark(
                                x: .value("Position", $0.xVal),
                                y: .value("Height", $0.yVal)

                            )
                            .foregroundStyle($plotData.plotArray[selector].changingPlotParameters.lineColor.wrappedValue)
                            PointMark(x: .value("Position", $0.xVal), y: .value("Height", $0.yVal))
                            
                            .foregroundStyle($plotData.plotArray[selector].changingPlotParameters.lineColor.wrappedValue)
                            
                            
                        }
                        .chartYScale(domain: [ plotData.plotArray[selector].changingPlotParameters.yMin ,  plotData.plotArray[selector].changingPlotParameters.yMax ])
                        .chartXScale(domain: [ plotData.plotArray[selector].changingPlotParameters.xMin ,  plotData.plotArray[selector].changingPlotParameters.xMax ])
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                        .padding()
                        Text($plotData.plotArray[selector].changingPlotParameters.xLabel.wrappedValue)
                            .foregroundColor(.red)
                    }
                }
               // .frame(width: 350, height: 400, alignment: .center)
                .frame(alignment: .center)
                
            }
            .padding()
    
            
            Divider()
        
            HStack{
                
                HStack(alignment: .center) {
                    Text("mu:")
                        .font(.callout)
                        .bold()
                    TextField("mu", text: $muInput)
                        .padding()
                }.padding()
                
                Toggle(isOn: $isChecked) {
                            Text("Display Error")
                        }
                .padding()
                
                
            }
            
            
            HStack{
                Button("One-Cycle", action: {
                    
                    Task.init{
                    
                    self.selector = 0
                    await self.calculate()
                    }
                    
                    
                    
                }
                
                
                )
                .padding()
                
            }
            
            HStack{
                Button("Bifurcation", action: { Task.init{
                    
                    self.selector = 1
                    
                    await self.bifurcation()
                    
                    
                }
                }
                
                
                )
                .padding()
                
            }
            
        }
        
    }
    
    @MainActor func setupPlotDataModel(selector: Int){
        
        calculator.plotDataModel = self.plotData.plotArray[selector]
    }
    
    
    /// calculate
    /// Function accepts the command to start the calculation from the GUI
    func calculate() async {
        
        //pass the plotDataModel to the Calculator
       // calculator.plotDataModel = self.plotData.plotArray[0]
        
        setupPlotDataModel(selector: 0)
        
     //   Task{
            
            
            let _ = await withTaskGroup(of:  Void.self) { taskGroup in



                taskGroup.addTask {

        
                    let mu = await Double(muInput)!
        
        
        
        //Calculate the new plotting data and place in the plotDataModel
                    await calculator.calculateOneCycle(mu: mu)
        
                    // This forces a SwiftUI update. Force a SwiftUI update.
        //await self.plotData.objectWillChange.send()
             
                    await setObjectWillChange(theObject: self.plotData)
                    
                    
                
                }

                
            }
            
  //      }
        
        
    }
    
    @MainActor func setObjectWillChange(theObject:PlotClass){
        
        theObject.objectWillChange.send()
        
    }
    
    /// calculate
    /// Function accepts the command to start the calculation from the GUI
    func bifurcation() async {
        
        
        //pass the plotDataModel to the Calculator
       // calculator.plotDataModel = self.plotData.plotArray[0]
        
        setupPlotDataModel(selector: 1)
        
     //   Task{
            
            
            let _ = await withTaskGroup(of:  Void.self) { taskGroup in



                taskGroup.addTask {

        
        //var temp = 0.0
        
        
        
        //Calculate the new plotting data and place in the plotDataModel
                    await calculator.bifurcationCaclulation(muMin: 1.0, muMax: 4.0, step: 0.005)
                  
                    // This forces a SwiftUI update. Force a SwiftUI update.
       // await self.plotData.objectWillChange.send()
                    
                    await setObjectWillChange(theObject: self.plotData)
                    
                }
                
            }
            
    //    }
        
        

    }
    

   
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


