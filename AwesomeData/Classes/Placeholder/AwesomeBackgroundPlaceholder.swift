//
//  AwesomeBackgroundPlaceholder.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 02/12/2016.
//
//

import UIKit

open class AwesomeBackgroundPlaceholder: UIImageView {
    
}

extension UIView {
    
    public func addPlaceholderImage(named name: String, backgroundColor: UIColor = .clear, contentMode: UIViewContentMode = .center){
        let imageView = AwesomeBackgroundPlaceholder(image: UIImage(named: name))
        imageView.backgroundColor = backgroundColor
        imageView.frame = self.frame
        imageView.contentMode = contentMode
        imageView.layer.cornerRadius = self.layer.cornerRadius
        imageView.layer.masksToBounds = true
        self.superview?.addSubview(imageView)
        self.superview?.bringSubview(toFront: self)
        
        if #available(iOS 9.0, *) {
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        }
    }
    
    public func removePlaceholderImage(){
        for subview in subviews{
            if let subview = subview as? AwesomeBackgroundPlaceholder {
                subview.removeFromSuperview()
            }
        }
    }
    
}
