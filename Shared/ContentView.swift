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

    var body: some View {
    HStack{
        VStack {
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
        dataCalculator.plotBasic(stepSize: 0.1, startingPop: 500, startingTime: 0, endTime: 10)
        
    }
    
    func calculateInfection(){
        
        //pass the plotDataModel to the dataCalculator
        dataCalculator.plotDataModelS = self.plotDataModelS
        dataCalculator.plotDataModelZ = self.plotDataModelZ
        //Calculate the new plotting data and place in the plotDataModel
        dataCalculator.ploteToTheMinusX()
        
    }
    
    func calculateQuarantine(){
        
        //pass the plotDataModel to the dataCalculator
        dataCalculator.plotDataModelS = self.plotDataModelS
        dataCalculator.plotDataModelZ = self.plotDataModelZ
        //Calculate the new plotting data and place in the plotDataModel
        dataCalculator.plotYEqualsX()
        
    }
    
    func calculateTreatment(){
        
        //pass the plotDataModel to the dataCalculator
        dataCalculator.plotDataModelS = self.plotDataModelS
        dataCalculator.plotDataModelZ = self.plotDataModelZ
        //Calculate the new plotting data and place in the plotDataModel
        dataCalculator.ploteToTheMinusX()
        
    }
   
    func calculateErradication(){
        
        //pass the plotDataModel to the dataCalculator
        dataCalculator.plotDataModelS = self.plotDataModelS
        dataCalculator.plotDataModelZ = self.plotDataModelZ
        //Calculate the new plotting data and place in the plotDataModel
        dataCalculator.ploteToTheMinusX()
        
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

