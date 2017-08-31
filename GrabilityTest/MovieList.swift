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
    
    let movieList : Variable<[Movie]> = Variable([])
    
    let searchResults : Variable<[Movie]> = Variable([])
    
    
    func getMovieViewsByTypeAndCategory(type : MovieType, category: Category, movies: [Movie]) -> [MovieView]{
        
        var list: [MovieView] = [MovieView]()
        for mv in movies{
            if(mv.movieType == type && mv.category == category){
                list.append(movieToMovieView(movie: mv))
            }
        }
        return list
    }
    
    func movieToMovieView(movie: Movie) -> MovieView{
        let movieView = MovieView.init(title: movie.title, date: movie.date, description: movie.overview, votes: String(movie.voteCount), average: String(movie.voteAverage), posterPath: movie.posterPath, backdropPath: movie.backdropPath)
        return movieView
    }
    
    func getTheMostPopularInTheList(movies: [Movie]) -> Movie{
        
        var selectedMv : Movie!
        var value: Float = 0
        
        for mv in movies{
            if(value < mv.voteAverage){
                value = mv.voteAverage
                selectedMv = mv
            }
        }
        return selectedMv
    }
}
