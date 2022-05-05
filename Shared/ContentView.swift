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
    @ObservedObject var plotDataModel = PlotDataClass(fromLine: true)
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
                
                CorePlot(dataForPlot: $plotDataModel.plotData, changingPlotParameters: $plotDataModel.changingPlotParameters)
                    .setPlotPadding(left: 10)
                    .setPlotPadding(right: 10)
                    .setPlotPadding(top: 10)
                    .setPlotPadding(bottom: 10)
                    .padding()
                    .tabItem {
                        Text("Susceptible Plot")
                    }
                
                CorePlot(dataForPlot: $plotDataModel.plotData, changingPlotParameters: $plotDataModel.changingPlotParameters)
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
    
    func calculateYEqualsX(){
        
        //pass the plotDataModel to the dataCalculator
        dataCalculator.plotDataModel = self.plotDataModel
        //Calculate the new plotting data and place in the plotDataModel
        dataCalculator.plotYEqualsX()
        
    }
    
    func calculateYEqualseToTheMinusX(){
        
        //pass the plotDataModel to the dataCalculator
        dataCalculator.plotDataModel = self.plotDataModel
        //Calculate the new plotting data and place in the plotDataModel
        dataCalculator.ploteToTheMinusX()
        
    }
   
    func calculateModel(){
        if modelVal == .basic {
            return self.calculateYEqualseToTheMinusX()
        }
        else if modelVal == .infection {
            return self.calculateYEqualsX()
        }
        else if modelVal == .quarantine {
            return self.calculateYEqualseToTheMinusX()
        }
        else if modelVal == .treatment {
            return self.calculateYEqualsX()
        }
        else if modelVal == .erradication {
            return self.calculateYEqualseToTheMinusX()
        }
    }
    
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/

