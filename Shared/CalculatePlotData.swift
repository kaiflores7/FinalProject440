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
    
    //Basic Model
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

    //Latent Infection model
    func plotInfection(stepSize: Double, startingPop: Double, startingTime: Double, endTime: Double){
        
        func dS(S: Double, Z: Double, R: Double, I: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double) -> Double
        {
            return pi - beta*S*Z - delta*S
        }
        
        func dI(S: Double, Z: Double, R: Double, I: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double) -> Double
        {
            return beta*S*Z - rho*I - delta*I
        }
        
        func dZ(S: Double, Z: Double, R: Double, I: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double) -> Double
        {
            return rho*I + zeta*R - alpha*S*Z
        }
        
        func dR(S: Double, Z: Double, R: Double, I: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double) -> Double
        {
            return delta*S + delta*I + alpha*S*Z - zeta*R
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
        var lastI = 0.0
        
        
        let dataPointS: plotDataType = [.X: 0.0, .Y: lastS]
            solutionArrayS.append(contentsOf: [dataPointS])
        let dataPointZ: plotDataType = [.X: 0.0, .Y: lastR]
            solutionArrayZ.append(contentsOf: [dataPointZ])
        
        for i in stride(from: startingTime, to: endTime, by: stepSize){
            if lastS > 0 {
            let SiPlus1 = lastS + dS(S: lastS, Z: lastZ, R: lastR, I: lastI, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, rho: 5.0) * (stepSize)
            let RiPlus1 = lastR + dR(S: lastS, Z: lastZ, R: lastR, I: lastI, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, rho: 5.0) * (stepSize)
            let ZiPlus1 = lastZ + dZ(S: lastS, Z: lastZ, R: lastR, I: lastI, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, rho: 5.0) * (stepSize)
            let IiPlus1 = lastI + dZ(S: lastS, Z: lastZ, R: lastR, I: lastI, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, rho: 5.0) * (stepSize)

            lastS = SiPlus1
            lastR = RiPlus1
            lastZ = ZiPlus1
            lastI = IiPlus1
            
            let dataPointS: plotDataType = [.X: i, .Y: SiPlus1]
                solutionArrayS.append(contentsOf: [dataPointS])
            let dataPointZ: plotDataType = [.X: i, .Y: RiPlus1]
                solutionArrayZ.append(contentsOf: [dataPointZ])
            }
        }
    
        plotDataModelS!.appendData(dataPoint: solutionArrayS)
        plotDataModelZ!.appendData(dataPoint: solutionArrayZ)
        
        return
    }
    
    
    //Quarantine model. Introduces kappa(infected coming in) and sigma(zombies coming in) constants, gamma constant(people trying to escape), and dQ equation
    
    func plotQuarantine(stepSize: Double, startingPop: Double, startingTime: Double, endTime: Double){
        
        func dS(S: Double, Z: Double, R: Double, I: Double, Q: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, kappa: Double, sigma: Double, gamma: Double) -> Double
        {
            return pi - beta*S*Z - delta*S
        }
        
        func dI(S: Double, Z: Double, R: Double, I: Double, Q: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, kappa: Double, sigma: Double, gamma: Double) -> Double
        {
            return beta*S*Z - rho*I - delta*I - kappa*I
        }
        
        func dZ(S: Double, Z: Double, R: Double, I: Double, Q: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, kappa: Double, sigma: Double, gamma: Double) -> Double
        {
            return rho*I + zeta*R - alpha*S*Z - sigma*Z
        }
        
        func dR(S: Double, Z: Double, R: Double, I: Double, Q: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, kappa: Double, sigma: Double, gamma: Double) -> Double
        {
            return delta*S + delta*I + alpha*S*Z - zeta*R + gamma*Q
        }
        
        func dQ(S: Double, Z: Double, R: Double, I: Double, Q: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, kappa: Double, sigma: Double, gamma: Double) -> Double
        {
            return kappa*I + sigma*Z - gamma*Q
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
        var lastI = 0.0
        var lastQ = 0.0
        
        
        let dataPointS: plotDataType = [.X: 0.0, .Y: lastS]
            solutionArrayS.append(contentsOf: [dataPointS])
        let dataPointZ: plotDataType = [.X: 0.0, .Y: lastR]
            solutionArrayZ.append(contentsOf: [dataPointZ])
        
        for i in stride(from: startingTime, to: endTime, by: stepSize){
            if lastS > 0{
            let SiPlus1 = lastS + dS(S: lastS, Z: lastZ, R: lastR, I: lastI, Q: lastQ, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, rho: 5.0, kappa: 0.002, sigma: 0.01, gamma: 0.002) * (stepSize)
            let RiPlus1 = lastR + dR(S: lastS, Z: lastZ, R: lastR, I: lastI, Q: lastQ, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, rho: 5.0, kappa: 0.002, sigma: 0.01, gamma: 0.002) * (stepSize)
            let ZiPlus1 = lastZ + dZ(S: lastS, Z: lastZ, R: lastR, I: lastI, Q: lastQ, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, rho: 5.0, kappa: 0.002, sigma: 0.01, gamma: 0.002) * (stepSize)
            let IiPlus1 = lastI + dZ(S: lastS, Z: lastZ, R: lastR, I: lastI, Q: lastQ, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, rho: 5.0, kappa: 0.002, sigma: 0.01, gamma: 0.002) * (stepSize)
            let QiPlus1 = lastQ + dZ(S: lastS, Z: lastZ, R: lastR, I: lastI, Q: lastQ, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, rho: 5.0, kappa: 0.002, sigma: 0.01, gamma: 0.002) * (stepSize)
            
            lastS = SiPlus1
            lastR = RiPlus1
            lastZ = ZiPlus1
            lastI = IiPlus1
            lastQ = QiPlus1
            
            
            let dataPointS: plotDataType = [.X: i, .Y: SiPlus1]
                solutionArrayS.append(contentsOf: [dataPointS])
            let dataPointZ: plotDataType = [.X: i, .Y: RiPlus1]
                solutionArrayZ.append(contentsOf: [dataPointZ])
            }
        }
    
        plotDataModelS!.appendData(dataPoint: solutionArrayS)
        plotDataModelZ!.appendData(dataPoint: solutionArrayZ)
        
        return
    }
    
//Treatment Model. Takes Q away, introduces constant c (cured)
    
    func plotTreatment(stepSize: Double, startingPop: Double, startingTime: Double, endTime: Double){
        
        func dS(S: Double, Z: Double, R: Double, I: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, c: Double) -> Double
        {
            return pi - beta*S*Z - delta*S + c*Z
        }
        
        func dI(S: Double, Z: Double, R: Double, I: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, c: Double) -> Double
        {
            return beta*S*Z - rho*I - delta*I
        }
        
        func dZ(S: Double, Z: Double, R: Double, I: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, c: Double) -> Double
        {
            return rho*I + zeta*R - alpha*S*Z - c*Z
        }
        
        func dR(S: Double, Z: Double, R: Double, I: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, c: Double) -> Double
        {
            return delta*S + delta*I + alpha*S*Z - zeta*R
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
        var lastI = 0.0
        
        
        let dataPointS: plotDataType = [.X: 0.0, .Y: lastS]
            solutionArrayS.append(contentsOf: [dataPointS])
        let dataPointZ: plotDataType = [.X: 0.0, .Y: lastR]
            solutionArrayZ.append(contentsOf: [dataPointZ])
        
        for i in stride(from: startingTime, to: endTime, by: stepSize){
            if lastS > 0 {
            let SiPlus1 = lastS + dS(S: lastS, Z: lastZ, R: lastR, I: lastI, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, rho: 5.0, c: 0.02) * (stepSize)
            let RiPlus1 = lastR + dR(S: lastS, Z: lastZ, R: lastR, I: lastI, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, rho: 5.0, c: 0.02) * (stepSize)
            let ZiPlus1 = lastZ + dZ(S: lastS, Z: lastZ, R: lastR, I: lastI, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, rho: 5.0, c: 0.02) * (stepSize)
            let IiPlus1 = lastI + dZ(S: lastS, Z: lastZ, R: lastR, I: lastI, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, rho: 5.0, c: 0.02) * (stepSize)
            
            lastS = SiPlus1
            lastR = RiPlus1
            lastZ = ZiPlus1
            lastI = IiPlus1
            
            
            let dataPointS: plotDataType = [.X: i, .Y: SiPlus1]
                solutionArrayS.append(contentsOf: [dataPointS])
            let dataPointZ: plotDataType = [.X: i, .Y: RiPlus1]
                solutionArrayZ.append(contentsOf: [dataPointZ])
            }
        }
    
        plotDataModelS!.appendData(dataPoint: solutionArrayS)
        plotDataModelZ!.appendData(dataPoint: solutionArrayZ)
        
        return
    }
    
//Basic Model with addition of deltaZ function, and kappa and n constants
    
    func plotErradication(stepSize: Double, startingPop: Double, startingTime: Double, endTime: Double){
        
        func dS(S: Double, Z: Double, R: Double, deltaZ: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, kappa: Double, n: Double) -> Double
        {
            return pi - beta*S*Z - delta*S
        }
        
        func dZ(S: Double, Z: Double, R: Double, deltaZ: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, kappa: Double, n: Double) -> Double
        {
            return beta*S*Z + zeta*S - alpha*S*Z
        }
        
        func dR(S: Double, Z: Double, R: Double, deltaZ: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, kappa: Double, n: Double) -> Double
        {
            return delta*S + alpha*S*Z - zeta*R
        }
        
        func deltaZ(S: Double, Z: Double, R: Double, deltaZ: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, kappa: Double, n: Double) -> Double
        {
            return -kappa*n*Z
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
        var lastDeltaZ = 0.0
        
        
        let dataPointS: plotDataType = [.X: 0.0, .Y: lastS]
            solutionArrayS.append(contentsOf: [dataPointS])
        let dataPointZ: plotDataType = [.X: 0.0, .Y: lastR]
            solutionArrayZ.append(contentsOf: [dataPointZ])
        
        for i in stride(from: startingTime, to: endTime, by: stepSize){
        
            let SiPlus1 = lastS + dS(S: lastS, Z: lastZ, R: lastR, deltaZ: lastDeltaZ, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, kappa: 0.25, n:3.0) * (stepSize)
            let RiPlus1 = lastR + dR(S: lastS, Z: lastZ, R: lastR, deltaZ: lastDeltaZ, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, kappa: 0.25, n:3.0) * (stepSize)
            let ZiPlus1 = lastZ + dZ(S: lastS, Z: lastZ, R: lastR, deltaZ: lastDeltaZ, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, kappa: 0.25, n:3.0) * (stepSize)
            let deltaZiPlus1 = lastDeltaZ + dZ(S: lastS, Z: lastZ, R: lastR, deltaZ: lastDeltaZ, pi: 0.0, alpha: 0.005, beta: 0.0095, delta: 0.0001, zeta: 0.0001, kappa: 0.25, n:3.0) * (stepSize)
            
            
            lastS = SiPlus1
            lastR = RiPlus1
            lastZ = ZiPlus1
            lastDeltaZ = deltaZiPlus1
            
            
            
            let dataPointS: plotDataType = [.X: i, .Y: SiPlus1]
                solutionArrayS.append(contentsOf: [dataPointS])
            let dataPointZ: plotDataType = [.X: i, .Y: RiPlus1]
                solutionArrayZ.append(contentsOf: [dataPointZ])
        }
    
        plotDataModelS!.appendData(dataPoint: solutionArrayS)
        plotDataModelZ!.appendData(dataPoint: solutionArrayZ)
        
        return
    }
    
}
