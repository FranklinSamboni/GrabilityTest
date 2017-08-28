//
//  InitialMovieCell.swift
//  GrabilityTest
//
//  Created by Aplimovil on 8/28/17.
//  Copyright © 2017 Franklinsc. All rights reserved.
//

import UIKit

class InitialMovieCell: UITableViewCell {

    @IBOutlet var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieImage.backgroundColor = .blue
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
