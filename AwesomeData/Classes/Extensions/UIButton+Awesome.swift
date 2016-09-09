//
//  UIButton+Awesome.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 6/7/16.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

extension UIButton{
    
    public func setImage(_ url: String?, thumbnailUrl: String? = nil, placeholder: UIImage? = nil, state: UIControlState, completion:((_ image: UIImage?) -> Void)?) -> URLSessionDataTask?{
        self.layer.masksToBounds = true
        
        if let placeholder = placeholder {
            self.setImage(placeholder, for: state)
        }
        
        return UIImage.loadImage(url) { (image) in
            self.setImage(image, for: state)
            completion?(image)
        }
    }
    
}
