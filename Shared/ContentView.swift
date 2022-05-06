//
//  ContentView.swift
//  Shared
//
//  Created by Katia Flores on 4/05/22.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    @ObservedObject var plotDataModelS = PlotDataClass(fromLine: true)
    @ObservedObject var plotDataModelZ = PlotDataClass(fromLine: true)
    @ObservedObject private var dataCalculator = CalculatePlotData()
    
    @State var modelVal: ModelType = .basic
    @State var startPop: Int = 500
    @State var startZombie: Int = 0
    @State var stepSize: Double = 0.1
    @State var startTime: Double = 0
    @State var endTime: Double = 10
    @State var alpha: Double = 0.005
    
    private var doubleFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.minimumSignificantDigits = 1
        f.maximumSignificantDigits = 6
        return f
    }()
    
    private var intFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()
    
    var body: some View {
    HStack{
        VStack {
            //input values: step size, starting population, starting time, ending time
            VStack {
                Text("Starting Population")
                TextField("In thousands", value: $startPop, formatter: intFormatter)
                    .frame(width: 100.0)
                Text("Starting Zombie Population")
                TextField("In thousands", value: $startZombie, formatter: intFormatter)
                    .frame(width: 100.0)
                Text("Step Size")
                TextField("Step Size", value: $stepSize, formatter: doubleFormatter)
                    .frame(width: 100.0)
                Text("Starting Time")
                TextField("In years", value: $startTime, formatter: doubleFormatter)
                    .frame(width: 100.0)
                Text("Ending Time")
                TextField("In years", value: $endTime, formatter: doubleFormatter)
                    .frame(width: 100.0)
            }.padding()
            
            Text("Model")
            Picker("", selection: $modelVal) {
                ForEach(ModelType.allCases) {
                    model in Text(model.toString())
                }
            }.frame(width: 150.0)
            
            Button("Calculate", action: {self.calculateModel()} )
            .padding()
            
        }.padding()
        
        VStack{
            TabView {
                
                CorePlot(dataForPlot: $plotDataModelS.plotData, changingPlotParameters: $plotDataModelS.changingPlotParameters)
                    .setPlotPadding(left: 10)
                    .setPlotPadding(right: 10)
                    .setPlotPadding(top: 10)
                    .setPlotPadding(bottom: 10)
                    .padding()
                    .tabItem {
                        Text("Susceptible Plot")
                    }
                
                CorePlot(dataForPlot: $plotDataModelZ.plotData, changingPlotParameters: $plotDataModelZ.changingPlotParameters)
                    .setPlotPadding(left: 10)
                    .setPlotPadding(right: 10)
                    .setPlotPadding(top: 10)
                    .setPlotPadding(bottom: 10)
                    .padding()
                    .tabItem {
                        Text("Zombie Plot")
                    }
            }
    
            
            Divider()
            
        }
        
    }
    }
    
    func calculateBasic(){
        //pass the plotDataModel to the dataCalculator
        dataCalculator.plotDataModelS = self.plotDataModelS
        dataCalculator.plotDataModelZ = self.plotDataModelZ
        //Calculate the new plotting data and place in the plotDataModel
        dataCalculator.plotBasic(stepSize: stepSize, startingPop: startPop, startingZombies: startZombie, startingTime: startTime, endTime: endTime)
        
    }
    
    func calculateInfection(){
        
        //pass the plotDataModel to the dataCalculator
        dataCalculator.plotDataModelS = self.plotDataModelS
        dataCalculator.plotDataModelZ = self.plotDataModelZ
        //Calculate the new plotting data and place in the plotDataModel
        dataCalculator.plotInfection(stepSize: stepSize, startingPop: startPop, startingZombies: startZombie, startingTime: startTime, endTime: endTime)
        
    }
    
    func calculateQuarantine(){
        
        //pass the plotDataModel to the dataCalculator
        dataCalculator.plotDataModelS = self.plotDataModelS
        dataCalculator.plotDataModelZ = self.plotDataModelZ
        //Calculate the new plotting data and place in the plotDataModel
        dataCalculator.plotQuarantine(stepSize: stepSize, startingPop: startPop, startingZombies: startZombie, startingTime: startTime, endTime: endTime)
        
    }
    
    func calculateTreatment(){
        
        //pass the plotDataModel to the dataCalculator
        dataCalculator.plotDataModelS = self.plotDataModelS
        dataCalculator.plotDataModelZ = self.plotDataModelZ
        //Calculate the new plotting data and place in the plotDataModel
        dataCalculator.plotTreatment(stepSize: stepSize, startingPop: startPop, startingZombies: startZombie, startingTime: startTime, endTime: endTime)
        
    }
   
    func calculateErradication(){
        
        //pass the plotDataModel to the dataCalculator
        dataCalculator.plotDataModelS = self.plotDataModelS
        dataCalculator.plotDataModelZ = self.plotDataModelZ
        //Calculate the new plotting data and place in the plotDataModel
        dataCalculator.plotErradication(stepSize: stepSize, startingPop: startPop, startingZombies: startZombie, startingTime: startTime, endTime: endTime)
        
    }
    
    func calculateModel(){
        if modelVal == .basic {
            return self.calculateBasic()
        }
        else if modelVal == .infection {
            return self.calculateInfection()
        }
        else if modelVal == .quarantine {
        return self.calculateQuarantine()
        }
        else if modelVal == .treatment {
            return self.calculateTreatment()
        }
        else if modelVal == .erradication {
            return self.calculateErradication()
        }
    }
    
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/

