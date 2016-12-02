//
//  ImageTableViewCell.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 27/08/2016.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var pictureImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        pictureImageView.addPlaceholderImage(named: "placeholder")
    }
    
}
