//
//  Model.swift
//  FinalProject
//
//  Created by Katia Flores on 4/05/22.
//

import Foundation

typealias CoordTuple = (x: Double, y: Double)

//Models: Basic Model, Latent Infection Model, Quarantine Model, Treatment Model, Impulsive Erradication Model,
enum ModelType: CaseIterable, Identifiable {
    static var allCases : [ModelType] {
        return [.basic, .infection, .quarantine, .treatment, .erradication]
    }
    case basic
    case infection
    case quarantine
    case treatment
    case erradication
    
    var id: Self { self }
    
    func toString() -> String {
        switch self {
            
        case .basic:
            return "Basic"
        case .infection:
            return "Latent Infection"
        case .quarantine:
            return "Quarantine"
        case .treatment:
            return "Treatment"
        case .erradication:
            return "Impulsive Erradication"
            
            
        }
    }
}
