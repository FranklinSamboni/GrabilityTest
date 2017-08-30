//
//  MovieType.swift
//  GrabilityTest
//
//  Created by Aplimovil on 8/29/17.
//  Copyright © 2017 Franklinsc. All rights reserved.
//

import Foundation

enum MovieType {
    case
    Movie,
    TVSerie,
    Unknow

    static func fromNumber(number: Int) -> MovieType{
        
        switch number {
        case 0:
            return .Movie
        case 1:
            return .TVSerie
        default:
            return .Unknow
        }
        
    }
    
}
