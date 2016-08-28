//
//  UICollectionViewCell+Awesome.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 6/7/16.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

extension UICollectionViewCell{
    
    public func setImage(url: String?, thumbnailUrl: String? = nil, placeholder: UIImage? = nil, imageViewName: String, collectionView: UICollectionView, indexPath: NSIndexPath, completion:((image: UIImage?) -> Void)?) -> NSURLSessionDataTask?{
        
        if let imageView = self.valueForKey(imageViewName) as? UIImageView {
            return imageView.setImage(url, placeholder: placeholder) { (image) in
                
                if let updateCell = collectionView.cellForItemAtIndexPath(indexPath) {
                    if let imageView = updateCell.valueForKey(imageViewName) as? UIImageView {
                        imageView.image = image
                    }
                }
                
                completion?(image: image)
            }
        } else {
            completion?(image: nil)
        }
        
        return nil
    }
    
}