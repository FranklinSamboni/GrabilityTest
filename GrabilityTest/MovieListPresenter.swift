//
//  MovieListPresenter.swift
//  GrabilityTest
//
//  Created by Aplimovil on 8/28/17.
//  Copyright © 2017 Franklinsc. All rights reserved.
//

import Foundation
import RxSwift

class MovieListPresenter {
    
    deinit {
        print("MovieListPresenter ha sido removido de memoria")
    }
    
    var theMovieDBServices : TheMovieDBServices!
    var movieDao: MovieDao!
    
    weak var movieListView: MovieListView!
    weak var movieDetailsView: MovieDetailsView!
    
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
    
    func addMovieDetailsView(movieDetailsView: MovieDetailsView){
        self.movieDetailsView = movieDetailsView
    }
    
    func removeMovieDetailsView() {
        movieDetailsView = nil
    }
    
    func getDetails(cellIdentifier: String, item: Int){
        
        var mv : Movie = Movie()
        
        switch cellIdentifier {
        case "popularMovieCell":
            mv = MovieList.shared.popularMovies.value[item]
        case "topRatedMovieCell":
            mv = MovieList.shared.topRatedMovies.value[item]
        case "upcomingMovieCell":
            mv = MovieList.shared.upcomingMovies.value[item]
        case "popularTVSerieCell":
            mv = MovieList.shared.popularTvSeries.value[item]
        case "topRatedTVSerieCell":
            mv = MovieList.shared.topRatedTVSeries.value[item]
        default:
            
            break
            
        }
        
        if(mv.id != nil){
            movieDetailsView.showDetails(imagePath: mv.posterPath, title: mv.title, date: mv.date, voteCount: String(mv.voteCount), voteAverage: String(mv.voteAverage), overview: mv.overview)
        }
    }
    
    func setupMovieListObservers(){
        
        MovieList.shared.popularMovies.asObservable().subscribe(
            onNext: { (movies) in
            
                if( movies.count > 0){
                    let mv = self.getTheMostPopularInTheList(movies: movies)
                    self.movieListView.showInitialMovie(path: mv.backdropPath, title: mv.title)
                }
                
                self.movieListView.showPopularMovies(imagePath: self.getImagePaths(movies: movies), categoryTitle: "Popular movies")
                
                
        }, onError: { (error) in
            print(error)
        }).addDisposableTo(disposeBag)
        
        MovieList.shared.topRatedMovies.asObservable().subscribe(
            onNext: { (movies) in
                
                self.movieListView.showTopRatedMovies(imagePath: self.getImagePaths(movies: movies), categoryTitle: "Top rated movies")
                
        }, onError: { (error) in
            print(error)
        }).addDisposableTo(disposeBag)
        
        MovieList.shared.upcomingMovies.asObservable().subscribe(
            onNext: { (movies) in
                
                self.movieListView.showUpcomingMovies(imagePath: self.getImagePaths(movies: movies), categoryTitle: "Upcoming movies")
                
        }, onError: { (error) in
            print(error)
        }).addDisposableTo(disposeBag)
        
        MovieList.shared.popularTvSeries.asObservable().subscribe(
            onNext: { (movies) in
                
                self.movieListView.showPopularTVSeries(imagePath: self.getImagePaths(movies: movies), categoryTitle: "Popular TV series")
                
        }, onError: { (error) in
            print(error)
        }).addDisposableTo(disposeBag)
        
        MovieList.shared.topRatedTVSeries.asObservable().subscribe(
            onNext: { (movies) in
                
                self.movieListView.showTopRatedTVSeries(imagePath: self.getImagePaths(movies: movies), categoryTitle: "Top rated TV series")
                
        }, onError: { (error) in
            print(error)
        }).addDisposableTo(disposeBag)
        
    }
    
    
    func getMovieLists(){
        
        movieListView.showActivityIndicator()
        
        theMovieDBServices.getMovies(movieType: MovieType.Movie, category: Category.Popular, page: "1") { (popularMovies) in
            
            if(popularMovies.isEmpty){
                self.movieListView.hideActivityIndicator()
                self.movieListView.showError(msg: "Check your internet connection")
            }

            self.updateMoviesInDb(movies: popularMovies)
            self.updatePopularMovies()
                
            self.theMovieDBServices.getMovies(movieType: MovieType.Movie, category: Category.TopRated, page: "1", callback: { (topRatedMovies) in
                    
                if(topRatedMovies.isEmpty){
                    self.movieListView.hideActivityIndicator()
                    self.movieListView.showError(msg: "Check your internet connection")
                }
            
                self.updateMoviesInDb(movies: topRatedMovies)
                self.updateTopRatedMovies()
                        
                self.theMovieDBServices.getMovies(movieType: MovieType.Movie, category: Category.UpComing, page: "1", callback: { (upcomingMovies) in
                            
                    if(upcomingMovies.isEmpty){
                        self.movieListView.hideActivityIndicator()
                        self.movieListView.showError(msg: "Check your internet connection")
                    }
                    
                    self.updateMoviesInDb(movies: upcomingMovies)
                    self.updateUpComingMovies()
                    
                    self.theMovieDBServices.getMovies(movieType: MovieType.TVSerie, category: Category.Popular, page: "1", callback: { (popularTVSeries) in
                        
                        if(popularTVSeries.isEmpty){
                            self.movieListView.hideActivityIndicator()
                            self.movieListView.showError(msg: "Check your internet connection")
                        }
                        
                        self.updateMoviesInDb(movies: popularTVSeries)
                        self.updatePopularTVSeries()
                        
                        
                        self.theMovieDBServices.getMovies(movieType: MovieType.TVSerie, category: Category.TopRated, page: "1", callback: { (topRatedTVSeries) in
                            
                            if(topRatedTVSeries.isEmpty){
                                self.movieListView.hideActivityIndicator()
                                self.movieListView.showError(msg: "Check your internet connection")
                            }
                            
                            self.updateMoviesInDb(movies: topRatedTVSeries)
                            self.updateTopRatedTVSeries()
                            
                            
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
    
    private func updatePopularMovies(){
        MovieList.shared.popularMovies.value.removeAll()
        
        let dbList = movieDao.findByCategoryAndMovieType(mvType: MovieType.Movie, mvCategory: Category.Popular)
        
        for item in dbList{
            MovieList.shared.popularMovies.value.append(item)
        }
    }
    
    private func updateTopRatedMovies(){
        
        MovieList.shared.topRatedMovies.value.removeAll()
        
        let dbList = movieDao.findByCategoryAndMovieType(mvType: MovieType.Movie, mvCategory: Category.TopRated)
        
        for item in dbList{
            MovieList.shared.topRatedMovies.value.append(item)
        }
    }
    
    private func updateUpComingMovies(){
        MovieList.shared.upcomingMovies.value.removeAll()
        
        let dbList = movieDao.findByCategoryAndMovieType(mvType: MovieType.Movie, mvCategory: Category.UpComing)
        
        for item in dbList{
            MovieList.shared.upcomingMovies.value.append(item)
        }
    }
    
    private func updatePopularTVSeries(){
        MovieList.shared.popularTvSeries.value.removeAll()
        
        let dbList = movieDao.findByCategoryAndMovieType(mvType: MovieType.TVSerie, mvCategory: Category.Popular)
        
        for item in dbList{
            MovieList.shared.popularTvSeries.value.append(item)
        }
    }
    
    private func updateTopRatedTVSeries(){
        MovieList.shared.topRatedTVSeries.value.removeAll()
        
        let dbList = movieDao.findByCategoryAndMovieType(mvType: MovieType.TVSerie, mvCategory: Category.TopRated)
        
        for item in dbList{
            MovieList.shared.topRatedTVSeries.value.append(item)
        }
    }
    
    private func getImagePaths(movies: [Movie]) -> [String]{
        var paths = [String]()
    
        for movie in movies{
            paths.append(movie.posterPath)
        }
        return paths
    }
    
    private func getTheMostPopularInTheList(movies: [Movie]) -> Movie{
        
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
