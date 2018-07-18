//
//  CollectionViewCell.swift
//  videoSearch
//
//  Created by Arihant Arora on 7/17/18.
//  Copyright © 2018 Arihant Arora. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoThumbnail: UIImageView!
    var video: Video? {
        didSet {
            
            videoTitleLabel.text = video?.title
            
            guard let imageUrlstring = video?.thumbnailImage else {return}
            guard let imageUrl = URL(string:imageUrlstring) else {return}
            // print(imageUrl)
            
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                
                if let err = error {
                    print("failed to retrive our cover image: ", err)
                }
                
                guard let imagedata = data else {return}
                let image = UIImage (data:imagedata)
                DispatchQueue.main.async {
                    self.videoThumbnail.image = image
                }
                }.resume()
        }
    }
    
    
}
