//
//  MovieDetailsViewController.swift
//  GrabilityTest
//
//  Created by Aplimovil on 8/28/17.
//  Copyright © 2017 Franklinsc. All rights reserved.
//

import UIKit
import SDWebImage


class MovieDetailsViewController: UIViewController{

    
    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieDate: UILabel!
    @IBOutlet var movieCount: UILabel!
    
    @IBOutlet var movieAverage: UILabel!
    
    @IBOutlet var overview: UILabel!
    
    var movie: MovieView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func showDetails(){

        movieImage.sd_setImage(with: URL.init(string: movie.posterPath), completed: { (image, error, sdImageCacheType, url) in
            if(error != nil){
                self.movieImage.image  = #imageLiteral(resourceName: "notFoundImage")
            }
        })
        
        movieTitle.text = movie.title
        movieDate.text = movie.date
        movieCount.text = "votes " + movie.votes
        movieAverage.text = "average " + movie.average
        self.overview.text = movie.description
        
    }
    
    
}
