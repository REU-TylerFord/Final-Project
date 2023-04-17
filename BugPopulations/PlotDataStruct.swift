//
//  PlotDataStruct.swift
//  Test Plot Threaded Charts
//
//  Created by Jeff Terry on 8/25/22.
//


import Foundation
import Charts

struct PlotDataStruct: Identifiable {
    var id: Double { xVal }
    let xVal: Double
    let yVal: Double
}

