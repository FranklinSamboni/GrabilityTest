//
//  SearchViewController.swift
//  GrabilityTest
//
//  Created by Aplimovil on 8/28/17.
//  Copyright © 2017 Franklinsc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchView: class {
    func showMovies(identifier: String, categoryTitle: String, movies : [MovieView])
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SearchView, SelectedItemProtocol{

    @IBOutlet var wordTextField: UITextField!
    
    @IBOutlet var tableView: UITableView!
    
    private let throttleInterval = 0.01
    private let disposeBag = DisposeBag()
    private var searchPresenter: SearchPresenter!
    
    var cells : [String:CategoryCell] = [String:CategoryCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchPresenter = SearchPresenter.init(theMovieDBServices: TheMovieDBServices(), searchView: self)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let categoryCellNib = UINib(nibName: "CategoryCell", bundle: nil)
        self.tableView.register(categoryCellNib, forCellReuseIdentifier: "CategoryCell")
        
        setupTextChangeHandling()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToDetailsFromSearch"){
            let destination = segue.destination as! MovieDetailsViewController
            destination.movie = sender as! MovieView
        }
    }

    private func setupTextChangeHandling() {
        let word = wordTextField
            .rx
            .text //1
            .throttle(throttleInterval, scheduler: MainScheduler.instance) //2
        
        word
            .subscribe(onNext: { (text) in
            
                let wd = self.wordTextField.text!
                
                if wd.utf16.count > 2 {
                    self.searchPresenter.doSearch(word: wd)
                }
                else{
                    self.cells.removeAll()
                    self.tableView.reloadData()
                }
                
            }, onError: { (error) in
                print(error)
            })
            .addDisposableTo(disposeBag) //5

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
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
        

        let cCells = [CategoryCell](self.cells.values)
        return cCells[indexPath.row]
    
    }
    
    func selectedItemInCell(movieView: MovieView) {
        performSegue(withIdentifier: "goToDetailsFromSearch", sender: movieView)
    }
    
    func showMovies(identifier: String, categoryTitle: String, movies : [MovieView]){
        
        if(movies.count > 0){
        
        if cells[identifier] == nil{
            cells[identifier] = self.tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCell
        }
            
        cells[identifier]?.selectedItem = self
        cells[identifier]?.movies = movies
        cells[identifier]?.categoryLabel.text = categoryTitle
        cells[identifier]?.collectionView.reloadData()
        
        }
        else {
            if cells[identifier] != nil{
                cells.removeValue(forKey: identifier)
            }
        }
        
        tableView.reloadData()
    }
    
}
