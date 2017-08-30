//
//  MovieDetailsViewController.swift
//  GrabilityTest
//
//  Created by Aplimovil on 8/28/17.
//  Copyright © 2017 Franklinsc. All rights reserved.
//

import UIKit
import SDWebImage

protocol MovieDetailsView: class {
    func showDetails(imagePath:String, title: String, date: String,voteCount: String, voteAverage:String, overview: String)
}

class MovieDetailsViewController: UIViewController , MovieDetailsView{

    
    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieDate: UILabel!
    @IBOutlet var movieCount: UILabel!
    
    @IBOutlet var movieAverage: UILabel!
    
    @IBOutlet var overview: UILabel!
    
    var data: [String: Int]!
    var movieListPresenter: MovieListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieListPresenter.addMovieDetailsView(movieDetailsView: self)
        movieListPresenter.getDetails(cellIdentifier: (data.first?.key)!, item: (data.first?.value)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func showDetails(imagePath:String, title: String, date: String,voteCount: String, voteAverage:String, overview: String){

        movieImage.sd_setImage(with: URL.init(string: imagePath), completed: { (image, error, sdImageCacheType, url) in
            if(error != nil){
                self.movieImage.image  = #imageLiteral(resourceName: "notFoundImage")
            }
        })
        
        movieTitle.text = title
        movieDate.text = date
        movieCount.text = "votes " + voteCount
        movieAverage.text = "average " + voteAverage
        self.overview.text = overview
        
    }
    
    
}
