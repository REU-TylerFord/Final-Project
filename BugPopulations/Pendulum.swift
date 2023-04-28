//
//  Pendulum.swift
//  BugPopulations
//
//  Created by IIT phys 440 on 4/25/23.
//

import Foundation

@MainActor class Pendulum: ObservableObject{
    
    
    @Published var theta = [Double] ()
    @Published var thetaPrime = [Double] ()
    @Published var thetaDoublePrime = [Double] ()
    @Published var time = [Double] ()
    @Published var potentialEnergy = [Double] ()
    
    
    @Published var omega = 1.0
    var deltaX = 0.01
    var tMin = 0.0
    var arbitraryMass = 20.0  //in kilograms
    var arbitraryLength = 2.0 //in meters
   
    
    func singleWaveFunctionFinder(initialThetaPrime: Double, numberOfXSteps: Int, omega: Double) -> Double {
        
        time = []
        theta = []
        thetaPrime = []
        thetaDoublePrime = []
        
        time.append(tMin)
        theta.append(0.0)
        thetaPrime.append(initialThetaPrime)
        thetaDoublePrime.append(-1.0*pow(omega,2.0)*sin(theta[0]))
        
        
        
        
        
        for i in 1...(numberOfXSteps)  {
            
            let currenttime = tMin + Double(i) * deltaX
            time.append(currenttime)
            
            
            
            let thetaOfI = theta[i-1] + thetaPrime[i-1] * deltaX
            theta.append(thetaOfI)
            
            let thetaPrimeOfI = thetaPrime[i-1] + thetaDoublePrime[i-1] * deltaX
            thetaPrime.append(thetaPrimeOfI)
            
            let thetaDoublePrimeOfI = -1.0*pow(omega,2.0)*sin(theta[i-1])
            thetaDoublePrime.append(thetaDoublePrimeOfI)
            
            
            
        }
        
        potentialEnergy = theta
        
        for i in 1...(potentialEnergy.count) {
            
            potentialEnergy[i-1] = cos(potentialEnergy[i-1] * arbitraryMass * arbitraryLength)
            
            
        }
        
        
        
        print("The first crossing at theta=0 occurs at 337-->338. The number of steps is equal to 339 and is for the initial theta of 1")
        print(theta[337])
        print(theta[338])
        print("------------")
        print("The second crossing at theta=0 occurs at 677-->678. The number of steps is equal to 339")
        print(theta[677])
        print(theta[678])
        print("------------")
        print("The third crossing at theta=0 occurs at 1018-->1019. The number of steps is equal to 340. Although this is off by one time step, we can assume that our step size is not small enough to find the next smallest positive angle before crossing to the negative values of theta")
        print(theta[1018])
        print(theta[1019])
        
        print("Thus the period is constant and has a value of 339 times steps. This value would be equal to our period T")
        
        
        return theta.last!
        
    }
    

    
    
    
    
    
}
