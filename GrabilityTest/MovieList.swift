//
//  MovieLists.swift
//  GrabilityTest
//
//  Created by Aplimovil on 8/29/17.
//  Copyright © 2017 Franklinsc. All rights reserved.
//

import Foundation
import RxSwift

class MovieList {
    
    static let shared = MovieList()
    
    let popularMovies : Variable<[Movie]> = Variable([])
    let topRatedMovies : Variable<[Movie]> = Variable([])
    let upcomingMovies : Variable<[Movie]> = Variable([])
    let popularTvSeries : Variable<[Movie]> = Variable([])
    let topRatedTVSeries : Variable<[Movie]> = Variable([])
    
    let searchResults : Variable<[Movie]> = Variable([])
    
    
}
