//
//  Category.swift
//  GrabilityTest
//
//  Created by Aplimovil on 8/28/17.
//  Copyright © 2017 Franklinsc. All rights reserved.
//

import Foundation

enum Category {
    case
    Popular,
    TopRated,
    UpComing,
    Unknow
    
    
    static func fromNumber(number: Int) -> Category{
        
        switch number {
        case 0:
            return .Popular
        case 1:
            return .TopRated
        case 2:
            return .UpComing
        default:
            return .Unknow
        }
        
    }
    
}
