//
//  TheMovieDBServices.swift
//  GrabilityTest
//
//  Created by Aplimovil on 8/28/17.
//  Copyright © 2017 Franklinsc. All rights reserved.
//

import Foundation
import Alamofire

class TheMovieDBServices {
    
    static let URL_IMAGES = "https://image.tmdb.org/t/p/w640"
    
    
    private let API_KEY = "5f9b575bdd7b895c79917da012169744"
    
    let URL_BASE = "https://api.themoviedb.org/3"
    
    let URL_MOVIE = "/movie"
    let URL_TVSERIE = "/tv"
    
    let URL_POPULAR = "/popular"
    let URL_TOP_RATED = "/top_rated"
    let URL_UPCOMING = "/upcoming"
    
    let URL_OPTIONS = "?api_key=%@&language=en-US&page=%@"
    
    let URL_SEARCH = "/search/movie"
    let URL_QUERY = "&query=%@"
    
    let categories: [Category: String]!
    let movieTypes: [MovieType: String]!
    
    var alamofire : Alamofire.SessionManager!
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 6
        configuration.timeoutIntervalForResource = 6
        alamofire = Alamofire.SessionManager(configuration: configuration)
        
        categories = [Category.Popular:URL_POPULAR,
                      Category.TopRated:URL_TOP_RATED,
                      Category.UpComing:URL_UPCOMING]
        
        movieTypes = [MovieType.Movie: URL_MOVIE,
                     MovieType.TVSerie: URL_TVSERIE]
    }

    
    func getMovies(movieType: MovieType, category: Category, page: String, callback:@escaping (_ popularMovies: [Movie]) -> Void){

        let url = URL_BASE + movieTypes[movieType]! + categories[category]! + String.localizedStringWithFormat(URL_OPTIONS, API_KEY, page)

        
        alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON{ response in
            
            let serverCode = response.response?.statusCode
            var movies : [Movie] = [Movie]()
            
            if serverCode == 200{
                if let data = (response.result.value) as? NSDictionary {

                    let results = data["results"] as! NSArray
                    
                    for item in results{
                        
                        var movie: Movie!
                        
                        if(movieType == MovieType.TVSerie){
                            movie = Movie.getTVSerieFromJSON(json: item as! NSDictionary)
                        }else{
                            movie = Movie.getMovieFromJSON(json: item as! NSDictionary)
                        }
                        
                        movie.movieType = movieType
                        movie.category = category
                        
                        movies.append(movie)
                    }
                    
                    callback(movies)
                    
                }
                else{
                    callback(movies)
                }
            }
            else{
                callback(movies)
            }
            
        }
    }
    
    func searchMovies(word: String, page: String ,callback:@escaping (_ movies: [Movie]) -> Void){
        
        let url = URL_BASE + URL_SEARCH + String.localizedStringWithFormat(URL_OPTIONS, API_KEY, page) + String.localizedStringWithFormat(URL_QUERY, word)

        alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON{ response in
            
            let serverCode = response.response?.statusCode
            var movies : [Movie] = [Movie]()
            
            if serverCode == 200{
                if let data = (response.result.value) as? NSDictionary {
                    
                    let results = data["results"] as! NSArray
                    
                    for item in results{
                        
                        var movie = Movie.getMovieFromJSON(json: item as! NSDictionary)
                        
                        movie.category = Category.Unknow
                        movie.movieType = MovieType.Unknow
                        
                        movies.append(movie)
                        
                    }
                    callback(movies)
                    
                }
                else{
                    callback(movies)
                }
            }
            else{
                callback(movies)
            }
        }
        
    }
    
}
