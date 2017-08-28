//
//  ViewController.swift
//  GrabilityTest
//
//  Created by Aplimovil on 8/27/17.
//  Copyright © 2017 Franklinsc. All rights reserved.
//

import UIKit

protocol MovieListView {
    //func showMovies(popular)
}

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillLayoutSubviews() {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }
        else{
            return 3
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
            let cell = Bundle.main.loadNibNamed("InitialMovieCell", owner: self, options: nil)?.first as! InitialMovieCell
            return cell
        }
        else{
            let cell = Bundle.main.loadNibNamed("CategoryCell", owner: self, options: nil)?.first as! CategoryCell
            return cell
        }
        
    }
    
}

