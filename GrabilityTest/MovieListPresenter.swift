//
//  MovieListPresenter.swift
//  GrabilityTest
//
//  Created by Aplimovil on 8/28/17.
//  Copyright © 2017 Franklinsc. All rights reserved.
//

import Foundation
import RxSwift

struct MovieView {

    var title: String
    var date: String
    var description: String
    
    var votes: String
    var average: String
    
    var posterPath: String
    var backdropPath: String
    
}

class MovieListPresenter {
    
    deinit {
        print("MovieListPresenter ha sido removido de memoria")
    }
    
    var theMovieDBServices : TheMovieDBServices!
    var movieDao: MovieDao!
    
    weak var movieListView: MovieListView!
    
    let disposeBag = DisposeBag()
    
    init(theMovieDBServices : TheMovieDBServices) {
        self.theMovieDBServices = theMovieDBServices
        movieDao = MovieDao()
    }
    
    init(theMovieDBServices : TheMovieDBServices, movieListView: MovieListView) {
        self.theMovieDBServices = theMovieDBServices
        self.movieListView = movieListView
        movieDao = MovieDao()
    }
    
    func addMovieListView(movieListView: MovieListView){
        self.movieListView = movieListView
    }
    
    func removeMovieListView() {
        movieListView = nil
    }
    
    func setupMovieListObservers(){
        
        MovieList.shared.movieList.asObservable().subscribe(
            onNext: { (movies) in
            
                if( movies.count > 0){
                    let mv = MovieList.shared.getTheMostPopularInTheList(movies: movies)
                    self.movieListView.showInitialMovie(path: mv.backdropPath, title: mv.title)
                }
                
                let popularMovies:[MovieView] = MovieList.shared.getMovieViewsByTypeAndCategory(type: MovieType.Movie, category: Category.Popular, movies: movies)
                let topRatedMovies:[MovieView] = MovieList.shared.getMovieViewsByTypeAndCategory(type: MovieType.Movie, category: Category.TopRated, movies: movies)
                let upcomingMovies:[MovieView] = MovieList.shared.getMovieViewsByTypeAndCategory(type: MovieType.Movie, category: Category.UpComing, movies: movies)
                let popularTVSeries:[MovieView] = MovieList.shared.getMovieViewsByTypeAndCategory(type: MovieType.TVSerie, category: Category.Popular, movies: movies)
                let topRatedTVSeries:[MovieView] = MovieList.shared.getMovieViewsByTypeAndCategory(type: MovieType.TVSerie, category: Category.TopRated, movies: movies)
                
                self.movieListView.showPopularMovies(movies: popularMovies, categoryTitle: "Popular movies")
                
                self.movieListView.showTopRatedMovies(movies: topRatedMovies, categoryTitle: "Top rated movies")
                
                self.movieListView.showUpcomingMovies(movies: upcomingMovies, categoryTitle: "Upcoming movies")

                self.movieListView.showPopularTVSeries(movies: popularTVSeries, categoryTitle: "Popular TV series")

                self.movieListView.showTopRatedTVSeries(movies: topRatedTVSeries, categoryTitle: "Top rated TV series")
                
        }, onError: { (error) in
            print(error)
        }).addDisposableTo(disposeBag)
        
    }
    
    
    func getMovieLists(){
        
        movieListView.showActivityIndicator()
        
        theMovieDBServices.getMovies(movieType: MovieType.Movie, category: Category.Popular, page: "1") { (popularMovies) in
            
            if(popularMovies.isEmpty){
                self.movieListView.hideActivityIndicator()
                //self.movieListView.showError(msg: "Check your internet connection")
            }

            self.updateMoviesInDb(movies: popularMovies)
            self.updateMovieList()
            
            self.theMovieDBServices.getMovies(movieType: MovieType.Movie, category: Category.TopRated, page: "1", callback: { (topRatedMovies) in
                    
                if(topRatedMovies.isEmpty){
                    self.movieListView.hideActivityIndicator()
                    //self.movieListView.showError(msg: "Check your internet connection")
                }
            
                self.updateMoviesInDb(movies: topRatedMovies)
                self.updateMovieList()
                        
                self.theMovieDBServices.getMovies(movieType: MovieType.Movie, category: Category.UpComing, page: "1", callback: { (upcomingMovies) in
                            
                    if(upcomingMovies.isEmpty){
                        self.movieListView.hideActivityIndicator()
                        //self.movieListView.showError(msg: "Check your internet connection")
                    }
                    
                    self.updateMoviesInDb(movies: upcomingMovies)
                    self.updateMovieList()
                    
                    self.theMovieDBServices.getMovies(movieType: MovieType.TVSerie, category: Category.Popular, page: "1", callback: { (popularTVSeries) in
                        
                        if(popularTVSeries.isEmpty){
                            self.movieListView.hideActivityIndicator()
                            //self.movieListView.showError(msg: "Check your internet connection")
                        }
                        
                        self.updateMoviesInDb(movies: popularTVSeries)
                        self.updateMovieList()
                        
                        
                        self.theMovieDBServices.getMovies(movieType: MovieType.TVSerie, category: Category.TopRated, page: "1", callback: { (topRatedTVSeries) in
                            
                            if(topRatedTVSeries.isEmpty){
                                self.movieListView.hideActivityIndicator()
                                //self.movieListView.showError(msg: "Check your internet connection")
                            }
                            
                            self.updateMoviesInDb(movies: topRatedTVSeries)
                            self.updateMovieList()
                            
                            
                        })
                        
                    })
                            
                })
    
            })
            
        }
    }
    
    private func updateMoviesInDb(movies: [Movie]){
        for movie in movies{
            
            if let mv = movieDao.findById(idMovie: movie.id){
                _ = movieDao.update(movie: mv)
            }
            else{
                _ = movieDao.insert(movie: movie)
            }
            
        }
    }
    
    private func updateMovieList(){
        MovieList.shared.movieList.value.removeAll()
        
        let dbList = movieDao.getAll()
        
        for item in dbList{
            MovieList.shared.movieList.value.append(item)
        }
    }
    
}
