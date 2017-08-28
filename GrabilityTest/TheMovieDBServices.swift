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
    
    let URL_BASE = "https://api.themoviedb.org/3/"
    
    let URL_POPULAR = "/movie/popular"
    let URL_TO_PRATED = "/movie/top_rated"
    let URL_UPCOMING = "/movie/upcoming"
    
    let URL_OPTIONS = "?api_key=%@&language=en-US&page=%@"
    
    let categories: [String]!
    
    var alamofire : Alamofire.SessionManager!
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        alamofire = Alamofire.SessionManager(configuration: configuration)
        
        categories = [URL_POPULAR,
                      URL_TO_PRATED,
                      URL_UPCOMING]
    }

    
    func getMovies(category: Int, page: String, callback:@escaping (_ popularMovies: [Movie]) -> Void){
        
        let url = URL_BASE + categories[category] + String.localizedStringWithFormat(URL_OPTIONS, API_KEY, page)
        
        alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON{ response in
            
            let serverCode = response.response?.statusCode
            var movies : [Movie] = [Movie]()
            
            if serverCode == 200{
                if let data = (response.result.value) as? NSDictionary {

                    let results = data["results"] as! NSArray
                    
                    for item in results{
                        let movie = Movie.getMovieFromJSON(json: item as! NSDictionary)
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
