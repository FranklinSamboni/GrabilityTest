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

    
    init(theMovieDBServices : TheMovieDBServices, searchView: SearchView) {
        self.theMovieDBServices = theMovieDBServices
        self.searchView = searchView
        movieDao = MovieDao()
    }
    
    func doSearch(word: String){
        
        theMovieDBServices.searchMovies(word: word, page: "1") { (movies) in
            
            let dbMovieList = self.movieDao.findByTitle(title: word)
            
            var searchList: [Movie] = [Movie]()
    
            if movies.count > 0{
                searchList = movies
                
                var isInside : Bool = false
                
                for item in dbMovieList{
                    for index in 0..<searchList.count {
                        if item.id == searchList[index].id {
                            searchList[index] = item // se actualiza la categoria y tipo de movie
                            isInside = true
                        }
                    }
                    if(!isInside){
                        searchList.append(item)
                    }
                    isInside = false
                }
            }
            else{
                searchList = dbMovieList
            }
            
            let popularMovies = MovieList.shared.getMovieViewsByTypeAndCategory(type: MovieType.Movie, category: Category.Popular, movies: searchList)
            let topRatedMovies = MovieList.shared.getMovieViewsByTypeAndCategory(type: MovieType.Movie, category: Category.TopRated, movies: searchList)
            let upcomingMovies = MovieList.shared.getMovieViewsByTypeAndCategory(type: MovieType.Movie, category: Category.UpComing, movies: searchList)
            let popularTVSeries = MovieList.shared.getMovieViewsByTypeAndCategory(type: MovieType.TVSerie, category: Category.Popular, movies: searchList)
            let topRatedTVSeries = MovieList.shared.getMovieViewsByTypeAndCategory(type: MovieType.TVSerie, category: Category.TopRated, movies: searchList)
            
            let unknowType = MovieList.shared.getMovieViewsByTypeAndCategory(type: MovieType.Unknow, category: Category.Unknow, movies: searchList)
            
            self.searchView.showMovies(identifier: "popularMovies", categoryTitle: "Popular movies", movies : popularMovies)
            
            self.searchView.showMovies(identifier: "topRatedMovies", categoryTitle: "Top rated movies", movies : topRatedMovies)
            
            self.searchView.showMovies(identifier: "upcomingMovies", categoryTitle: "Upcoming movies", movies : upcomingMovies)
            
            self.searchView.showMovies(identifier: "popularTVSeries", categoryTitle: "Popular TV series", movies : popularTVSeries)
            
            self.searchView.showMovies(identifier: "topRatedTVSeries", categoryTitle: "Top rated series", movies : topRatedTVSeries)
            
            self.searchView.showMovies(identifier: "others", categoryTitle: "Others", movies : unknowType)
            
            
            
        }
        
    }
    
}
