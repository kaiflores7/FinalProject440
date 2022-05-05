//
//  CalculatePlotData.swift
//  SwiftUICorePlotExample
//
//  Created by Jeff Terry on 12/22/20.
//

import Foundation
import SwiftUI
import CorePlot

class CalculatePlotData: ObservableObject {
    
    var plotDataModel: PlotDataClass? = nil
    var plotDataModelS: PlotDataClass? = nil
    var plotDataModelZ: PlotDataClass? = nil
    
    func plotBasic(stepSize: Double, startingPop: Double, startingTime: Double, endTime: Double){
        
        func dS(S: Double, Z: Double, R: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double) -> Double
        {
            return pi - beta*S*Z - delta*S
        }
        
        func dZ(S: Double, Z: Double, R: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double) -> Double
        {
            return beta*S*Z + zeta*S - alpha*S*Z
        }
        
        func dR(S: Double, Z: Double, R: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double) -> Double
        {
            return delta*S + alpha*S*Z - zeta*R
        }
        
        plotDataModelS!.changingPlotParameters.yMax = 700.0
        plotDataModelS!.changingPlotParameters.yMin = 0.0
        plotDataModelS!.changingPlotParameters.xMax = 10.0
        plotDataModelS!.changingPlotParameters.xMin = 0.0
        plotDataModelS!.changingPlotParameters.xLabel = "Time"
        plotDataModelS!.changingPlotParameters.yLabel = "Susceptible"
        plotDataModelS!.changingPlotParameters.lineColor = .blue()
        plotDataModelS!.changingPlotParameters.title = "Susceptible people over time"
        
        plotDataModelZ!.changingPlotParameters.yMax = 1000.0
        plotDataModelZ!.changingPlotParameters.yMin = 0.0
        plotDataModelZ!.changingPlotParameters.xMax = 10.0
        plotDataModelZ!.changingPlotParameters.xMin = 0.0
        plotDataModelZ!.changingPlotParameters.xLabel = "Time"
        plotDataModelZ!.changingPlotParameters.yLabel = "Zombie"
        plotDataModelZ!.changingPlotParameters.lineColor = .red()
        plotDataModelZ!.changingPlotParameters.title = "Zombie population over time"
        
        plotDataModelS!.zeroData()
        var solutionArrayS :[plotDataType] =  []
        plotDataModelZ!.zeroData()
        var solutionArrayZ :[plotDataType] =  []
        
        var lastS = startingPop
        var lastZ = 0.0
        var lastR = 0.0
        
        
        let dataPointS: plotDataType = [.X: 0.0, .Y: lastS]
            solutionArrayS.append(contentsOf: [dataPointS])
        let dataPointZ: plotDataType = [.X: 0.0, .Y: lastR]
            solutionArrayZ.append(contentsOf: [dataPointZ])
        
        for i in stride(from: startingTime, to: endTime, by: stepSize){
            
            let SiPlus1 = lastS + dS(S: lastS, Z: lastZ, R: lastR, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001) * (stepSize)
            let RiPlus1 = lastR + dR(S: lastS, Z: lastZ, R: lastR, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001) * (stepSize)
            let ZiPlus1 = lastZ + dZ(S: lastS, Z: lastZ, R: lastR, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001) * (stepSize)
            
            
            lastS = SiPlus1
            lastR = RiPlus1
            lastZ = ZiPlus1
            
            
            
            let dataPointS: plotDataType = [.X: i, .Y: SiPlus1]
                solutionArrayS.append(contentsOf: [dataPointS])
            let dataPointZ: plotDataType = [.X: i, .Y: RiPlus1]
                solutionArrayZ.append(contentsOf: [dataPointZ])
        }
    
        plotDataModelS!.appendData(dataPoint: solutionArrayS)
        plotDataModelZ!.appendData(dataPoint: solutionArrayZ)
        
        return
    }


    func plotYEqualsX()
    {
        
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = 10.0
        plotDataModel!.changingPlotParameters.yMin = -5.0
        plotDataModel!.changingPlotParameters.xMax = 10.0
        plotDataModel!.changingPlotParameters.xMin = -5.0
        plotDataModel!.changingPlotParameters.xLabel = "time"
        plotDataModel!.changingPlotParameters.yLabel = "y"
        plotDataModel!.changingPlotParameters.lineColor = .red()
        plotDataModel!.changingPlotParameters.title = " y = x"
        
        plotDataModel!.zeroData()
        var plotData :[plotDataType] =  []
        
        
        for i in 0 ..< 120 {

            //create x values here

            let x = -2.0 + Double(i) * 0.2

        //create y values here

        let y = x


            let dataPoint: plotDataType = [.X: x, .Y: y]
            plotData.append(contentsOf: [dataPoint])
        
        }
        
        plotDataModel!.appendData(dataPoint: plotData)
        
        
    }
    
    
    func ploteToTheMinusX()
    {
        
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = 10
        plotDataModel!.changingPlotParameters.yMin = -3.0
        plotDataModel!.changingPlotParameters.xMax = 10.0
        plotDataModel!.changingPlotParameters.xMin = -3.0
        plotDataModel!.changingPlotParameters.xLabel = "time"
        plotDataModel!.changingPlotParameters.yLabel = "y = exp(-x)"
        plotDataModel!.changingPlotParameters.lineColor = .blue()
        plotDataModel!.changingPlotParameters.title = "exp(-x)"

        plotDataModel!.zeroData()
        var plotData :[plotDataType] =  []
        for i in 0 ..< 60 {

            //create x values here

            let x = -2.0 + Double(i) * 0.2

        //create y values here

        let y = exp(-x)
            
            let dataPoint: plotDataType = [.X: x, .Y: y]
            plotData.append(contentsOf: [dataPoint])
        }
        
        plotDataModel!.appendData(dataPoint: plotData)
        
        return
    }
    
}
