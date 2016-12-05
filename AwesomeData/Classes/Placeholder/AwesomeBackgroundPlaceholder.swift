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
        removePlaceholderImage()
        
        let imageView = AwesomeBackgroundPlaceholder(image: UIImage(named: name))
        imageView.backgroundColor = backgroundColor
        imageView.frame = self.frame
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = contentMode
        imageView.layer.cornerRadius = self.layer.cornerRadius
        imageView.layer.masksToBounds = true
        self.superview?.insertSubview(imageView, belowSubview: self)
        
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
    
    public func copyConstraints(toView: UIView){
        guard let constraints = self.superview?.constraints else {
            return
        }
        
        for constraint in constraints {
            if constraint.firstItem as? NSObject == self {
                self.superview?.addConstraints([
                    NSLayoutConstraint(item: toView,
                                       attribute: constraint.firstAttribute,
                                       relatedBy: constraint.relation,
                                       toItem: constraint.secondItem,
                                       attribute: constraint.secondAttribute,
                                       multiplier: constraint.multiplier,
                                       constant: constraint.constant)
                    ])
            } else if constraint.secondItem as? NSObject == self {
                self.superview?.addConstraints([
                    NSLayoutConstraint(item: constraint.firstItem,
                                       attribute: constraint.firstAttribute,
                                       relatedBy: constraint.relation,
                                       toItem: toView,
                                       attribute: constraint.secondAttribute,
                                       multiplier: constraint.multiplier,
                                       constant: constraint.constant)
                    ])
            }
        }
    }
    
}
