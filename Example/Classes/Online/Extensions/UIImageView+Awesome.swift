//
//  UIImageView+Awesome.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 6/7/16.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

extension UIImageView{
    
    public func setImage(url: String?, thumbnailUrl: String? = nil, placeholder: UIImage? = nil, completion:((image: UIImage?) -> Void)?) -> NSURLSessionDataTask?{
        self.layer.masksToBounds = true
        
        if let placeholder = placeholder {
            self.image = placeholder
        }
        
        return UIImage.loadImage(url) { (image) in
            self.image = image
            completion?(image: image)
        }
    }
    
}