//
//  functions.swift
//  BugPopulations
//
//  Created by IIT phys 440 on 4/21/23.
//

import SwiftUI

class Wavefunctions: ObservableObject {
    @Published var wavefunction = [(xPoint: Double, psiPoint: Double)] ()
    @Published var waveOneDerivative = [(xPoint: Double, psiPrimePoint: Double)]()
    @Published var waveTwoDerivative = [(xPoint: Double, psiTwoPrimePoint: Double)]()
}
