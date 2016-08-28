//
//  ViewController.swift
//  AwesomeDataDemo
//
//  Created by Evandro Harrison Hoffmann on 24/08/2016.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

class AwesomeDataDemoViewController: UICollectionViewController {
    
    var unsplashImages = [UnsplashImage]()
    let cellSize = UIScreen.mainScreen().bounds.width/2 - 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unsplashImages = UnsplashImage.list() as! [UnsplashImage]
        AwesomeDataDemoAPI.fetchUnsplashImages({ (unsplashImages) in
            self.unsplashImages.removeAll()
            self.unsplashImages.appendContentsOf(unsplashImages)
            self.collectionView?.reloadData()
        }) { (message) in
            print("Error: \(message)")
        }
    }
}

// MARK: - TableViewDataSource

extension AwesomeDataDemoViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsplashImages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("image", forIndexPath: indexPath) as! ImageCollectionViewCell
        
        cell.setImage(unsplashImages[indexPath.row].imageUrl(CGSize(width: cellSize, height: cellSize)), imageViewName: "pictureImageView", collectionView: collectionView, indexPath: indexPath, completion: { (image) in
            
        })
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
}
