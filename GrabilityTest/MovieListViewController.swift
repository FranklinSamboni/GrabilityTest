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
    
    func showPopularMovies(imagePath: [String], categoryTitle: String)
    func showTopRatedMovies(imagePath: [String], categoryTitle: String)
    func showUpcomingMovies(imagePath: [String], categoryTitle: String)
    func showPopularTVSeries(imagePath: [String], categoryTitle: String)
    func showTopRatedTVSeries(imagePath: [String], categoryTitle: String)
    
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
    
    var movieListPresenter: MovieListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView()
        
        movieListPresenter = MovieListPresenter(theMovieDBServices: TheMovieDBServices(), movieListView: self)
        
        movieListPresenter.getMovieLists()
        movieListPresenter.setupMovieListObservers()

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
            destination.data = sender  as! [String : Int]
            destination.movieListPresenter = movieListPresenter
        }
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
    
    func showPopularMovies(imagePath: [String], categoryTitle: String){
        popularMovieCell.categoryLabel.text = categoryTitle
        popularMovieCell.movieImages = imagePath
        popularMovieCell.collectionView.reloadData()
    }
    
    func showTopRatedMovies(imagePath: [String], categoryTitle: String){
        topRatedMovieCell.categoryLabel.text = categoryTitle
        topRatedMovieCell.movieImages = imagePath
        topRatedMovieCell.collectionView.reloadData()
    }
    
    func showUpcomingMovies(imagePath: [String], categoryTitle: String){
        upcomingMovieCell.categoryLabel.text = categoryTitle
        upcomingMovieCell.movieImages = imagePath
        upcomingMovieCell.collectionView.reloadData()
    }
    
    func showPopularTVSeries(imagePath: [String], categoryTitle: String){
        popularTVSerieCell.categoryLabel.text = categoryTitle
        popularTVSerieCell.movieImages = imagePath
        popularTVSerieCell.collectionView.reloadData()
    }
    
    func showTopRatedTVSeries(imagePath: [String], categoryTitle: String){
        topRatedTVSerieCell.categoryLabel.text = categoryTitle
        topRatedTVSerieCell.movieImages = imagePath
        topRatedTVSerieCell.collectionView.reloadData()
    }
    
    func showError(msg: String){
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func selectedItemInCell(cellIdentifier: String, item: Int) {
        performSegue(withIdentifier: "goToDetailsFromList", sender: [cellIdentifier: item])
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
        self.popularMovieCell.cellIdentifier = "popularMovieCell"
        self.popularMovieCell.selectedItem = self
        
        self.topRatedMovieCell = self.tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        self.topRatedMovieCell.cellIdentifier = "topRatedMovieCell"
        self.topRatedMovieCell.selectedItem = self
        
        self.upcomingMovieCell = self.tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        self.upcomingMovieCell.cellIdentifier = "upcomingMovieCell"
        self.upcomingMovieCell.selectedItem = self
    
        self.popularTVSerieCell = self.tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        self.popularTVSerieCell.cellIdentifier = "popularTVSerieCell"
        self.popularTVSerieCell.selectedItem = self

        self.topRatedTVSerieCell = self.tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        self.topRatedTVSerieCell.cellIdentifier = "topRatedTVSerieCell"
        self.topRatedTVSerieCell.selectedItem = self
        
        
    }
    
}

