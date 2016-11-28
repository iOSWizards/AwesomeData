//
//  UIImageView+Awesome.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 6/7/16.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

private var indexPathAssociationKey: UInt8 = 0

public extension UIImageView {
    
    final internal var indexPath: Int! {
        get {
            return objc_getAssociatedObject(self, &indexPathAssociationKey) as? Int
        }
        set {
            objc_setAssociatedObject(self, &indexPathAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func setImage(_ url: String?, thumbnailUrl: String? = nil, placeholder: UIImage? = nil, completion:((_ image: UIImage?) -> Void)?) -> URLSessionDataTask?{
        self.layer.masksToBounds = true
        
        self.image = nil
        
        if let placeholder = placeholder {
            self.image = placeholder
        }
        
        self.indexPath = -1
        
        let tableView: UITableView
        let collectionView: UICollectionView
        var tableViewCell: UITableViewCell?
        var collectionViewCell: UICollectionViewCell?
        var parentView = self.superview
        
        while parentView != nil {
            if let view = parentView as? UITableViewCell {
                tableViewCell = view
            }
            else if let view = parentView as? UITableView {
                tableView = view
                
                if let cell = tableViewCell {
                    let indexPath = tableView.indexPathForRow(at: cell.center)
                    self.indexPath = indexPath?.hashValue ?? -1
                }
                break
            }
            else if let view = parentView as? UICollectionViewCell {
                collectionViewCell = view
            }
            else if let view = parentView as? UICollectionView {
                collectionView = view
                
                if let cell = collectionViewCell {
                    let indexPath = collectionView.indexPathForItem(at: cell.center)
                    self.indexPath = indexPath?.hashValue ?? -1
                }
                break
            }
            
            parentView = parentView?.superview
        }
        
        let initialIndexPath = self.indexPath as Int
        
        
        return UIImage.loadImage(url) { (image) in
            if(initialIndexPath == self.indexPath) {
                self.image = image
                completion?(image)
            } else {
                return
            }
        }
    }
    
}

