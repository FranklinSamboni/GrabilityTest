//
//  SearchPresenter.swift
//  GrabilityTest
//
//  Created by Aplimovil on 8/30/17.
//  Copyright © 2017 Franklinsc. All rights reserved.
//

import Foundation
import RxSwift

class SearchPresenter {
    
    deinit {
        print("SearchPresenter ha sido removido de memoria")
    }
    
    var theMovieDBServices : TheMovieDBServices!
    var movieDao: MovieDao!
    
    weak var searchView: SearchView!
    
    let disposeBag = DisposeBag()
    
    init(theMovieDBServices : TheMovieDBServices) {
        self.theMovieDBServices = theMovieDBServices
        movieDao = MovieDao()
    }
    
    init(theMovieDBServices : TheMovieDBServices, searchView: SearchView) {
        self.theMovieDBServices = theMovieDBServices
        movieDao = MovieDao()
    }
    
    func doSearch(word: String){
        
        theMovieDBServices.searchMovies(word: word, page: "1") { (movies) in
            
            let dbMovieList = self.movieDao.findByTitle(title: word)
            
            MovieList.shared.searchResults.value.removeAll()
            
            if(movies.count > 0){
                for mv in movies{
                    MovieList.shared.searchResults.value.append(mv)
                    
                }
                for item in dbMovieList {
                    for index in 0..<movies.count{
                        if(item.id == movies[index].id){
                            MovieList.shared.searchResults.value[index] = item
                        }
                    }
                }
            }
            
            
            
        }
        
    }
    
}
