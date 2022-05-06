//
//  CalculatePlotData.swift
//  SwiftUICorePlotExample
//
//  Based on code by Jeff Terry on 12/22/20.
//

import Foundation
import SwiftUI
import CorePlot

class CalculatePlotData: ObservableObject {
    
    var plotDataModel: PlotDataClass? = nil
    var plotDataModelS: PlotDataClass? = nil
    var plotDataModelZ: PlotDataClass? = nil
    
//Basic Model
    
    func dS(S: Double, Z: Double, R: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double) -> Double
    {
        return pi - beta*Double(S*Z) - delta*Double(S)
    }
    
    func dZ(S: Double, Z: Double, R: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double) -> Double
    {
        return beta*Double(S*Z) + zeta*Double(R) - alpha*Double(S*Z)
    }
    
    func dR(S: Double, Z: Double, R: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double) -> Double
    {
        return delta*Double(S) + alpha*Double(S*Z) - zeta*Double(R)
    }
    
    
    func plotBasic(stepSize: Double, startingPop: Int, startingZombies: Int, startingTime: Double, endTime: Double){
        
        plotDataModelS!.changingPlotParameters.yMax = 700.0
        plotDataModelS!.changingPlotParameters.yMin = -100.0
        plotDataModelS!.changingPlotParameters.xMax = 11.0
        plotDataModelS!.changingPlotParameters.xMin = -1.0
        plotDataModelS!.changingPlotParameters.xLabel = "Time"
        plotDataModelS!.changingPlotParameters.yLabel = "Susceptible"
        plotDataModelS!.changingPlotParameters.lineColor = .blue()
        plotDataModelS!.changingPlotParameters.title = "Susceptible people over time"
        
        plotDataModelZ!.changingPlotParameters.yMax = 700.0
        plotDataModelZ!.changingPlotParameters.yMin = -100.0
        plotDataModelZ!.changingPlotParameters.xMax = 11.0
        plotDataModelZ!.changingPlotParameters.xMin = -1.0
        plotDataModelZ!.changingPlotParameters.xLabel = "Time"
        plotDataModelZ!.changingPlotParameters.yLabel = "Zombie"
        plotDataModelZ!.changingPlotParameters.lineColor = .red()
        plotDataModelZ!.changingPlotParameters.title = "Zombie population over time"
        
        plotDataModelS!.zeroData()
        var solutionArrayS :[plotDataType] =  []
        plotDataModelZ!.zeroData()
        var solutionArrayZ :[plotDataType] =  []
        
        var lastS = Double(startingPop-startingZombies)
        var lastZ = Double(startingZombies)
        var lastR = 0.0
        
        
        let pi = 0.0
        let alpha = 0.0005
        let beta = 0.0095
        let delta = 0.0001
        let zeta = 0.0001
        
        
        let dataPointS: plotDataType = [.X: 0.0, .Y: Double(lastS)]
            solutionArrayS.append(contentsOf: [dataPointS])
        let dataPointZ: plotDataType = [.X: 0.0, .Y: Double(lastZ)]
            solutionArrayZ.append(contentsOf: [dataPointZ])
        
        for i in stride(from: startingTime, to: endTime, by: stepSize){
            
            let SiPlus1 = lastS + dS(S: lastS, Z: lastZ, R: lastR, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta) * (stepSize)
            let RiPlus1 = lastR + dR(S: lastS, Z: lastZ, R: lastR, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta) * (stepSize)
            let ZiPlus1 = lastZ + dZ(S: lastS, Z: lastZ, R: lastR, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta) * (stepSize)
            
            if SiPlus1 >= 0 {
                    lastS = SiPlus1
            }
            else {
                
                lastS = 0
                
            }
            
            if RiPlus1 >= 0 {
                    lastR = RiPlus1
            }
            else {
                
                lastR = 0
                
            }
            
            if ZiPlus1 >= 0 {
                    lastZ = ZiPlus1
            }
            else {
                
                lastZ = 0
                
            }
            
            
            
            let dataPointS: plotDataType = [.X: i, .Y: Double(SiPlus1)]
                solutionArrayS.append(contentsOf: [dataPointS])
            let dataPointZ: plotDataType = [.X: i, .Y: Double(ZiPlus1)]
                solutionArrayZ.append(contentsOf: [dataPointZ])
        }
    
        plotDataModelS!.appendData(dataPoint: solutionArrayS)
        plotDataModelZ!.appendData(dataPoint: solutionArrayZ)
        
        return
    }

//Latent Infection model
    
    //Latent Infection model
    
    func dS_LI(S: Double, Z: Double, R: Double, I: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double) -> Double
    {
        return (pi - beta * Double(S*Z) - delta * Double(S))
    }
    
    func dI_LI(S: Double, Z: Double, R: Double, I: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double) -> Double
    {
        let changeInI = beta * Double(S*Z) - rho * Double(I) - delta * Double(I)
        return (changeInI)
    }
    
    func dZ_LI(S: Double, Z: Double, R: Double, I: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double) -> Double
    {
        let changeInZ = rho * Double(I) + zeta * Double(R) - alpha * Double(S*Z)
        print(changeInZ)
        return (changeInZ)
    }
    
    func dR_LI(S: Double, Z: Double, R: Double, I: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double) -> Double
    {
        return (delta * Double(S) + delta * Double(I) + alpha * Double(S*Z) - zeta * Double(R))
    }
    
    
    
    func plotInfection(stepSize: Double, startingPop: Int, startingZombies: Int, startingTime: Double, endTime: Double){
        
        
        
        
        plotDataModelS!.changingPlotParameters.yMax = 700.0
        plotDataModelS!.changingPlotParameters.yMin = -100.0
        plotDataModelS!.changingPlotParameters.xMax = endTime+0.1*endTime
        plotDataModelS!.changingPlotParameters.xMin = -1.0
        plotDataModelS!.changingPlotParameters.xLabel = "Time"
        plotDataModelS!.changingPlotParameters.yLabel = "Susceptible"
        plotDataModelS!.changingPlotParameters.lineColor = .blue()
        plotDataModelS!.changingPlotParameters.title = "Susceptible people over time"
        
        plotDataModelZ!.changingPlotParameters.yMax = 700.0
        plotDataModelZ!.changingPlotParameters.yMin = -100.0
        plotDataModelZ!.changingPlotParameters.xMax = endTime+0.1*endTime
        plotDataModelZ!.changingPlotParameters.xMin = -1.0
        plotDataModelZ!.changingPlotParameters.xLabel = "Time"
        plotDataModelZ!.changingPlotParameters.yLabel = "Zombie"
        plotDataModelZ!.changingPlotParameters.lineColor = .red()
        plotDataModelZ!.changingPlotParameters.title = "Zombie population over time"
        
        plotDataModelS!.zeroData()
        var solutionArrayS :[plotDataType] =  []
        plotDataModelZ!.zeroData()
        var solutionArrayZ :[plotDataType] =  []
        
        var lastS = Double(startingPop-startingZombies)
        var lastZ = Double(startingZombies)
        var lastR = 0.0
        var lastI = 0.0
        
        
        let pi = 0.0
        let alpha = 0.0005
        let beta = 0.0095
        let delta = 0.0001
        let zeta = 0.0001
        let rho = 0.005
        
        print (lastS, lastR, lastZ, lastI)
        
        let dataPointS: plotDataType = [.X: 0.0, .Y: Double(lastS + lastR)]
            solutionArrayS.append(contentsOf: [dataPointS])
        let dataPointZ: plotDataType = [.X: 0.0, .Y: Double(lastZ + lastI)]
            solutionArrayZ.append(contentsOf: [dataPointZ])
        
    
        
        for i in stride(from: startingTime, to: endTime, by: stepSize){
            
            
            let SiPlus1 = lastS + dS_LI(S: lastS, Z: lastZ, R: lastR, I: lastI, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, rho: rho) * (stepSize)
            let RiPlus1 = lastR + dR_LI(S: lastS, Z: lastZ, R: lastR, I: lastI, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, rho: rho) * (stepSize)
            let ZiPlus1 = lastZ + dZ_LI(S: lastS, Z: lastZ, R: lastR, I: lastI, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, rho: rho) * (stepSize)
            let IiPlus1 = lastI + dI_LI(S: lastS, Z: lastZ, R: lastR, I: lastI, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, rho: rho) * (stepSize)
            
            if SiPlus1 >= 0 {
                    lastS = SiPlus1
            }
            else {
                lastS = 0
            }
            
            if RiPlus1 >= 0 {
                    lastR = RiPlus1
            }
            else {
                lastR = 0
            }
            
            if ZiPlus1 >= 0 {
                    lastZ = ZiPlus1
            }
            else {
                lastZ = 0
            }
            
            if IiPlus1 >= 0 {
                    lastI = IiPlus1
            }
            else {
                lastI = 0
            }
            
            print (lastS, lastR, lastZ, lastI)
            
            
            let dataPointS: plotDataType = [.X: i, .Y: Double(lastS + lastR)]
                solutionArrayS.append(contentsOf: [dataPointS])
            let dataPointZ: plotDataType = [.X: i, .Y: Double(lastZ + lastI)]
                solutionArrayZ.append(contentsOf: [dataPointZ])
            
        }
    
        plotDataModelS!.appendData(dataPoint: solutionArrayS)
        plotDataModelZ!.appendData(dataPoint: solutionArrayZ)
        
        return
    }
    
//Quarantine model. Introduces kappa(infected coming in) and sigma(zombies coming in) constants, gamma constant(people trying to escape), and dQ equation
    func dS_Q(S: Double, Z: Double, R: Double, I: Double, Q: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, kappa: Double, sigma: Double, gamma: Double) -> Double
    {
        return (pi - beta * Double(S*Z) - delta * Double(S))
    }
    
    
    func dI_Q(S: Double, Z: Double, R: Double, I: Double, Q: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, kappa: Double, sigma: Double, gamma: Double) -> Double
    {
        let changeInI = beta * Double(S*Z) - rho * Double(I) - delta * Double(I) - kappa * Double(I)
        return (changeInI)
    }
    
    func dZ_Q(S: Double, Z: Double, R: Double, I: Double, Q: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, kappa: Double, sigma: Double, gamma: Double) -> Double
    {
        let changeInZ = rho * Double(I) + zeta * Double(R) - alpha * Double(S*Z) - sigma * Double(Z)
        print(changeInZ)
        return (changeInZ)
    }
    
    func dR_Q(S: Double, Z: Double, R: Double, I: Double, Q: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, kappa: Double, sigma: Double, gamma: Double) -> Double
    {
        return (delta * Double(S) + delta * Double(I) + alpha * Double(S*Z) - zeta * Double(R) + gamma * Double(Q))
    }
    
    func dQ_Q(S: Double, Z: Double, R: Double, I: Double, Q: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, kappa: Double, sigma: Double, gamma: Double) -> Double
    {
        return (kappa * Double(I) + sigma * Double(Z) - gamma * Double(Q))
    }
    
    
    func plotQuarantine(stepSize: Double, startingPop: Int, startingZombies: Int, startingTime: Double, endTime: Double){
        
        plotDataModelS!.changingPlotParameters.yMax = 700.0
        plotDataModelS!.changingPlotParameters.yMin = -100.0
        plotDataModelS!.changingPlotParameters.xMax = endTime+0.1*endTime
        plotDataModelS!.changingPlotParameters.xMin = -1.0
        plotDataModelS!.changingPlotParameters.xLabel = "Time"
        plotDataModelS!.changingPlotParameters.yLabel = "Susceptible"
        plotDataModelS!.changingPlotParameters.lineColor = .blue()
        plotDataModelS!.changingPlotParameters.title = "Susceptible people over time"
        
        plotDataModelZ!.changingPlotParameters.yMax = 700.0
        plotDataModelZ!.changingPlotParameters.yMin = -100.0
        plotDataModelZ!.changingPlotParameters.xMax = endTime+0.1*endTime
        plotDataModelZ!.changingPlotParameters.xMin = -1.0
        plotDataModelZ!.changingPlotParameters.xLabel = "Time"
        plotDataModelZ!.changingPlotParameters.yLabel = "Zombie"
        plotDataModelZ!.changingPlotParameters.lineColor = .red()
        plotDataModelZ!.changingPlotParameters.title = "Zombie population over time"
        
        plotDataModelS!.zeroData()
        var solutionArrayS :[plotDataType] =  []
        plotDataModelZ!.zeroData()
        var solutionArrayZ :[plotDataType] =  []
        
        var lastS = Double(startingPop-startingZombies)
        var lastZ = Double(startingZombies)
        var lastR = 0.0
        var lastI = 0.0
        var lastQ = 0.0
        
        let pi = 0.0
        let alpha = 0.0005
        let beta = 0.0095
        let delta = 0.0001
        let zeta = 0.0001
        let rho = 0.5
        let kappa = 0.002
        let sigma = 0.01
        let gamma = 0.002
        
        print (lastS, lastR, lastZ, lastI, lastQ)
        
        let dataPointS: plotDataType = [.X: 0.0, .Y: Double(lastS + lastR)]
            solutionArrayS.append(contentsOf: [dataPointS])
        let dataPointZ: plotDataType = [.X: 0.0, .Y: Double(lastZ + lastI)]
            solutionArrayZ.append(contentsOf: [dataPointZ])
        
        for i in stride(from: startingTime, to: endTime, by: stepSize){
            
            let SiPlus1 = lastS + dS_Q(S: lastS, Z: lastZ, R: lastR, I: lastI, Q: lastQ, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, rho: rho, kappa: kappa, sigma: sigma, gamma: gamma) * (stepSize)
            let RiPlus1 = lastR + dR_Q(S: lastS, Z: lastZ, R: lastR, I: lastI, Q: lastQ, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, rho: rho, kappa: kappa, sigma: sigma, gamma: gamma) * (stepSize)
            let ZiPlus1 = lastZ + dZ_Q(S: lastS, Z: lastZ, R: lastR, I: lastI, Q: lastQ, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, rho: rho, kappa: kappa, sigma: sigma, gamma: gamma) * (stepSize)
            let IiPlus1 = lastI + dZ_Q(S: lastS, Z: lastZ, R: lastR, I: lastI, Q: lastQ, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, rho: rho, kappa: kappa, sigma: sigma, gamma: gamma) * (stepSize)
            let QiPlus1 = lastQ + dZ_Q(S: lastS, Z: lastZ, R: lastR, I: lastI, Q: lastQ, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, rho: rho, kappa: kappa, sigma: sigma, gamma: gamma) * (stepSize)
            
            if SiPlus1 >= 0 {
                    lastS = SiPlus1
            }
            else {
                
                lastS = 0
                
            }
            
            if RiPlus1 >= 0 {
                    lastR = RiPlus1
            }
            else {
                
                lastR = 0
                
            }
            
            if ZiPlus1 >= 0 {
                    lastZ = ZiPlus1
            }
            else {
                
                lastZ = 0
                
            }
            
            if IiPlus1 >= 0 {
                    lastI = IiPlus1
            }
            else {
                
                lastI = 0
                
            }
            
            if QiPlus1 >= 0 {
                    lastQ = QiPlus1
            }
            else {
                
                lastQ = 0
                
            }
            
            print (lastS, lastR, lastZ, lastI)
            
            
            let dataPointS: plotDataType = [.X: i, .Y: Double(lastS + lastR)]
                solutionArrayS.append(contentsOf: [dataPointS])
            let dataPointZ: plotDataType = [.X: i, .Y: Double(lastZ + lastI + lastQ)]
                solutionArrayZ.append(contentsOf: [dataPointZ])
        }
    
        plotDataModelS!.appendData(dataPoint: solutionArrayS)
        plotDataModelZ!.appendData(dataPoint: solutionArrayZ)
        
        return
    }
    
//Treatment Model. Takes Q away, introduces constant c (cured)
    func dS_T(S: Double, Z: Double, R: Double, I: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, c: Double) -> Double
    {
        return (pi - beta * Double(S*Z) - delta * Double(S) + c * Double(Z))
    }
    
    func dI_T(S: Double, Z: Double, R: Double, I: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, c: Double) -> Double
    {
        let changeInI = beta * Double(S*Z) - rho * Double(I) - delta * Double(I)
        return (changeInI)
    }
    
    func dZ_T(S: Double, Z: Double, R: Double, I: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, c: Double) -> Double
    {
        let changeInZ = rho * Double(I) + zeta * Double(R) - alpha * Double(S*Z) - c * Double(Z)
        print(changeInZ)
        return (changeInZ)
    }
    
    func dR_T(S: Double, Z: Double, R: Double, I: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, rho: Double, c: Double) -> Double
    {
        return (delta * Double(S) + delta * Double(I) + alpha * Double(S*Z) - zeta * Double(R))
    }
    
    func plotTreatment(stepSize: Double, startingPop: Int, startingZombies: Int, startingTime: Double, endTime: Double){
        
        plotDataModelS!.changingPlotParameters.yMax = 700.0
        plotDataModelS!.changingPlotParameters.yMin = -100.0
        plotDataModelS!.changingPlotParameters.xMax = endTime+0.1*endTime
        plotDataModelS!.changingPlotParameters.xMin = -1.0
        plotDataModelS!.changingPlotParameters.xLabel = "Time"
        plotDataModelS!.changingPlotParameters.yLabel = "Susceptible"
        plotDataModelS!.changingPlotParameters.lineColor = .blue()
        plotDataModelS!.changingPlotParameters.title = "Susceptible people over time"
        
        plotDataModelZ!.changingPlotParameters.yMax = 700.0
        plotDataModelZ!.changingPlotParameters.yMin = -100.0
        plotDataModelZ!.changingPlotParameters.xMax = endTime+0.1*endTime
        plotDataModelZ!.changingPlotParameters.xMin = -1.0
        plotDataModelZ!.changingPlotParameters.xLabel = "Time"
        plotDataModelZ!.changingPlotParameters.yLabel = "Zombie"
        plotDataModelZ!.changingPlotParameters.lineColor = .red()
        plotDataModelZ!.changingPlotParameters.title = "Zombie population over time"
        
        plotDataModelS!.zeroData()
        var solutionArrayS :[plotDataType] =  []
        plotDataModelZ!.zeroData()
        var solutionArrayZ :[plotDataType] =  []
        
        var lastS = Double(startingPop - startingZombies)
        var lastZ = Double(startingZombies)
        var lastR = 0.0
        var lastI = 0.0
        
        let pi = 0.0
        let alpha = 0.0005
        let beta = 0.0095
        let delta = 0.0001
        let zeta = 0.0001
        let rho = 0.5
        let c = 0.02
        
        print (lastS, lastR, lastZ, lastI)
        
        let dataPointS: plotDataType = [.X: 0.0, .Y: lastS]
            solutionArrayS.append(contentsOf: [dataPointS])
        let dataPointZ: plotDataType = [.X: 0.0, .Y: lastR]
            solutionArrayZ.append(contentsOf: [dataPointZ])
        
        for i in stride(from: startingTime, to: endTime, by: stepSize){
            
            let SiPlus1 = lastS + dS_T(S: lastS, Z: lastZ, R: lastR, I: lastI, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, rho: rho, c: c) * (stepSize)
            let RiPlus1 = lastR + dR_T(S: lastS, Z: lastZ, R: lastR, I: lastI, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, rho: rho, c: c) * (stepSize)
            let ZiPlus1 = lastZ + dZ_T(S: lastS, Z: lastZ, R: lastR, I: lastI, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, rho: rho, c: c) * (stepSize)
            let IiPlus1 = lastI + dI_T(S: lastS, Z: lastZ, R: lastR, I: lastI, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, rho: rho, c: c) * (stepSize)
            
            if SiPlus1 >= 0 {
                               lastS = SiPlus1
                       }
                       else {
                           
                           lastS = 0
                           
                       }
                       
                       if RiPlus1 >= 0 {
                               lastR = RiPlus1
                       }
                       else {
                           
                           lastR = 0
                           
                       }
                       
                       if ZiPlus1 >= 0 {
                               lastZ = ZiPlus1
                       }
                       else {
                           
                           lastZ = 0
                           
                       }
                       
                       if IiPlus1 >= 0 {
                               lastI = IiPlus1
                       }
                       else {
                           
                           lastI = 0
                           
                       }
            
            
            let dataPointS: plotDataType = [.X: i, .Y: SiPlus1]
                solutionArrayS.append(contentsOf: [dataPointS])
            let dataPointZ: plotDataType = [.X: i, .Y: RiPlus1]
                solutionArrayZ.append(contentsOf: [dataPointZ])
        }
    
        plotDataModelS!.appendData(dataPoint: solutionArrayS)
        plotDataModelZ!.appendData(dataPoint: solutionArrayZ)
        
        return
    }
    
//Basic Model with addition of deltaZ function, and kappa and n constants
        func dS_E(S: Double, Z: Double, R: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, kappa: Double, n: Double) -> Double
        {
            return pi - beta*Double(S*Z) - delta*Double(S)
        }
        
        func dZ_E(S: Double, Z: Double, R: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, kappa: Double, n: Double) -> Double
        {
            return beta*Double(S*Z) + zeta*Double(R) - alpha*Double(S*Z)
        }
        
        func dR_E(S: Double, Z: Double, R: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, kappa: Double, n: Double) -> Double
        {
            return delta*Double(S) + alpha*Double(S*Z) - zeta*Double(R)
        }
    
        func deltaZ_E(S: Double, Z: Double, R: Double, pi: Double, alpha: Double, beta: Double, delta: Double, zeta: Double, kappa: Double, n: Double) -> Double
        {
            return ( -kappa*n*Double(Z))
        }
    
    func plotErradication(stepSize: Double, startingPop: Int, startingZombies: Int, startingTime: Double, endTime: Double){
        
        plotDataModelS!.changingPlotParameters.yMax = 700.0
        plotDataModelS!.changingPlotParameters.yMin = -100.0
        plotDataModelS!.changingPlotParameters.xMax = 11.0
        plotDataModelS!.changingPlotParameters.xMin = -1.0
        plotDataModelS!.changingPlotParameters.xLabel = "Time"
        plotDataModelS!.changingPlotParameters.yLabel = "Susceptible"
        plotDataModelS!.changingPlotParameters.lineColor = .blue()
        plotDataModelS!.changingPlotParameters.title = "Susceptible people over time"
        
        plotDataModelZ!.changingPlotParameters.yMax = 700.0
        plotDataModelZ!.changingPlotParameters.yMin = -100.0
        plotDataModelZ!.changingPlotParameters.xMax = 11.0
        plotDataModelZ!.changingPlotParameters.xMin = -1.0
        plotDataModelZ!.changingPlotParameters.xLabel = "Time"
        plotDataModelZ!.changingPlotParameters.yLabel = "Zombie"
        plotDataModelZ!.changingPlotParameters.lineColor = .red()
        plotDataModelZ!.changingPlotParameters.title = "Zombie population over time"
        
        plotDataModelS!.zeroData()
        var solutionArrayS :[plotDataType] =  []
        plotDataModelZ!.zeroData()
        var solutionArrayZ :[plotDataType] =  []
        
        var lastS = Double(startingPop-startingZombies)
        var lastZ = Double(startingZombies)
        var lastR = 0.0
        var lastDeltaZ = 0.0
        
        let pi = 0.0
        let alpha = 0.0005
        let beta = 0.0095
        let delta = 0.0001
        let zeta = 0.0001
        let kappa = 0.25
        let n = 4.0
        
        let dataPointS: plotDataType = [.X: 0.0, .Y: lastS]
            solutionArrayS.append(contentsOf: [dataPointS])
        let dataPointZ: plotDataType = [.X: 0.0, .Y: lastR]
            solutionArrayZ.append(contentsOf: [dataPointZ])
        
        for i in stride(from: startingTime, to: endTime, by: stepSize){
            
            let SiPlus1 = lastS + dS_E(S: lastS, Z: lastZ, R: lastR, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, kappa: kappa, n: n) * (stepSize)
            let RiPlus1 = lastR + dR_E(S: lastS, Z: lastZ, R: lastR, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, kappa: kappa, n: n) * (stepSize)
            let ZiPlus1 = lastZ + dZ_E(S: lastS, Z: lastZ, R: lastR, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, kappa: kappa, n: n) * (stepSize)
            let deltaZiPlus1 = lastDeltaZ + deltaZ_E(S: lastS, Z: lastZ, R: lastR, pi: pi, alpha: alpha, beta: beta, delta: delta, zeta: zeta, kappa: kappa, n: n) * (stepSize)
            
            if SiPlus1 >= 0 {
                lastS = SiPlus1
            }
            else {
                lastS = 0
            }
            
            if RiPlus1 >= 0 {
                lastR = RiPlus1
            }
            else {
                lastR = 0
            }
            
            if ZiPlus1 >= 0 {
                lastZ = ZiPlus1
            }
            else {
                lastZ = 0
            }
            
            if deltaZiPlus1 >= 0 {
                lastDeltaZ = deltaZiPlus1
            }
            else {
                lastDeltaZ = 0
            }
            
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
