//
//  CategoryCell.swift
//  GrabilityTest
//
//  Created by Aplimovil on 8/28/17.
//  Copyright © 2017 Franklinsc. All rights reserved.
//

import UIKit
import SDWebImage

class CategoryCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var movieImages: [String] = [String]()
    
    var cellIdentifier: String!
    var selectedItem: SelectedItemProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        let nibName = UINib(nibName: "ImageCell", bundle:nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "ImageCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath as IndexPath) as! ImageCell
        
        cell.movieImage.sd_setImage(with: URL.init(string: movieImages[indexPath.row]), completed: { (image, error, sdImageCacheType, url) in
            if(error != nil){
                cell.movieImage.image  = #imageLiteral(resourceName: "notFoundImage")
            }
        })
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedItem.selectedItemInCell(cellIdentifier: cellIdentifier, item: indexPath.row)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: collectionView.frame.width * 0.35, height: collectionView.frame.height * 0.95)
    }

    
}
