//
//  ViewController.swift
//  GrabilityTest
//
//  Created by Aplimovil on 8/27/17.
//  Copyright © 2017 Franklinsc. All rights reserved.
//

import UIKit

protocol MovieListView : class {
    func showActivityIndicator()
    func hideActivityIndicator()
    
    func showInitialMovie(path: String, title: String)
    
    func showPopularMovies(movies: [MovieView], categoryTitle: String)
    func showTopRatedMovies(movies: [MovieView], categoryTitle: String)
    func showUpcomingMovies(movies: [MovieView], categoryTitle: String)
    func showPopularTVSeries(movies: [MovieView], categoryTitle: String)
    func showTopRatedTVSeries(movies: [MovieView], categoryTitle: String)
    
    func showError(msg: String)
}

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MovieListView, SelectedItemProtocol {
    
    @IBOutlet var tableView: UITableView!
    
    var initialMovieCell : InitialMovieCell!
    var popularMovieCell : CategoryCell!
    var topRatedMovieCell : CategoryCell!
    var upcomingMovieCell : CategoryCell!
    var popularTVSerieCell : CategoryCell!
    var topRatedTVSerieCell : CategoryCell!
    
    var rightBarButtonItem: UIBarButtonItem!
    
    var movieListPresenter: MovieListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView()
        
        movieListPresenter = MovieListPresenter(theMovieDBServices: TheMovieDBServices(), movieListView: self)
        
        movieListPresenter.getMovieLists()
        movieListPresenter.setupMovieListObservers()

        
        rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action: #selector(MovieListViewController.handleRightButton))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    override func viewWillLayoutSubviews() {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailsFromList" {
            let destination = segue.destination as! MovieDetailsViewController
            destination.movie = sender  as! MovieView
        }
    }
    
    func handleRightButton(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "goToSearchFromList", sender: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }
        else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            if UIDevice.current.orientation.isPortrait {
                return UIScreen.main.bounds.size.height * 0.30
            }
            else{
                return UIScreen.main.bounds.size.height * 0.60
            }
        }
        else{
            if UIDevice.current.orientation.isPortrait {
                return UIScreen.main.bounds.size.height * 0.25
            }
            else{
                return UIScreen.main.bounds.size.height * 0.50
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            return initialMovieCell
        }
        else{
            
            switch indexPath.row {
            case 0:
                return popularMovieCell
                
            case 1:
                return topRatedMovieCell
                
            case 2:
                return upcomingMovieCell
                
            case 3:
                return popularTVSerieCell
                
            case 4:
                return topRatedTVSerieCell
                
            default:
                return UITableViewCell()
            }
        }
        
    }
    
    func showActivityIndicator(){
        
    }
    
    func hideActivityIndicator(){
        
    }
    
    func showInitialMovie(path: String, title: String){
        
        initialMovieCell.movieName.text = title
        
        initialMovieCell.movieImage.sd_setImage(with: URL.init(string: path), completed: { (image, error, sdImageCacheType, url) in
            if(error != nil){
                self.initialMovieCell.movieImage.image  = #imageLiteral(resourceName: "notFoundImage")
            }
        })
    }
    
    func showPopularMovies(movies: [MovieView], categoryTitle: String){
        popularMovieCell.categoryLabel.text = categoryTitle
        popularMovieCell.movies = movies
        popularMovieCell.collectionView.reloadData()
    }
    
    func showTopRatedMovies(movies: [MovieView], categoryTitle: String){
        topRatedMovieCell.categoryLabel.text = categoryTitle
        topRatedMovieCell.movies = movies
        topRatedMovieCell.collectionView.reloadData()
    }
    
    func showUpcomingMovies(movies: [MovieView], categoryTitle: String){
        upcomingMovieCell.categoryLabel.text = categoryTitle
        upcomingMovieCell.movies = movies
        upcomingMovieCell.collectionView.reloadData()
    }
    
    func showPopularTVSeries(movies: [MovieView], categoryTitle: String){
        popularTVSerieCell.categoryLabel.text = categoryTitle
        popularTVSerieCell.movies = movies
        popularTVSerieCell.collectionView.reloadData()
    }
    
    func showTopRatedTVSeries(movies: [MovieView], categoryTitle: String){
        topRatedTVSerieCell.categoryLabel.text = categoryTitle
        topRatedTVSerieCell.movies = movies
        topRatedTVSerieCell.collectionView.reloadData()
    }
    
    func showError(msg: String){
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func selectedItemInCell(movieView: MovieView) {
        performSegue(withIdentifier: "goToDetailsFromList", sender: movieView)
    }
    
    private func settingTableView(){
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        
       
        let initialMovieCellNib = UINib(nibName: "InitialMovieCell", bundle: nil)
        self.tableView.register(initialMovieCellNib, forCellReuseIdentifier: "InitialMovieCell")
        self.initialMovieCell = self.tableView.dequeueReusableCell(withIdentifier: "InitialMovieCell") as! InitialMovieCell
        
        let categoryCellNib = UINib(nibName: "CategoryCell", bundle: nil)
        self.tableView.register(categoryCellNib, forCellReuseIdentifier: "CategoryCell")
        
        self.popularMovieCell = self.tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        self.popularMovieCell.selectedItem = self
        
        self.topRatedMovieCell = self.tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        self.topRatedMovieCell.selectedItem = self
        
        self.upcomingMovieCell = self.tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        self.upcomingMovieCell.selectedItem = self
    
        self.popularTVSerieCell = self.tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        self.popularTVSerieCell.selectedItem = self

        self.topRatedTVSerieCell = self.tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        self.topRatedTVSerieCell.selectedItem = self
        
    }
    
}

