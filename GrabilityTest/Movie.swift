//
//  Movie.swift
//  GrabilityTest
//
//  Created by Aplimovil on 8/28/17.
//  Copyright © 2017 Franklinsc. All rights reserved.
//

import Foundation

struct Movie {
    
    var id : Int!
    var title: String!
    var date: String!
    var overview: String!
    
    var voteCount: Int!
    var voteAverage: Float!
    
    var posterPath: String!
    var backdropPath: String!
    
    init() {
        
    }

    static func getMovieFromJSON(json: NSDictionary) -> Movie{
        
        var movie: Movie = Movie()
        
        if let id = json["id"] as? Int{
            movie.id = id
        }
        
        if let title = json["title"] as? String{
            movie.title = title
        }
        
        if let date = json["release_date"] as? String{
            movie.date = date
        }
        
        if let overview = json["overview"] as? String{
            movie.overview = overview
        }
        
        if let voteCount = json["vote_count"] as? Int{
            movie.voteCount = voteCount
        }
        
        if let voteAverage = json["vote_average"] as? Float{
            movie.voteAverage = voteAverage
        }
        
        if let posterPath = json["poster_path"] as? String{
            movie.posterPath = TheMovieDBServices.URL_IMAGES + posterPath
        }
        
        if let backdropPath = json["backdrop_path"] as? String{
            movie.backdropPath = TheMovieDBServices.URL_IMAGES + backdropPath
        }
        
        return movie
    }

}
