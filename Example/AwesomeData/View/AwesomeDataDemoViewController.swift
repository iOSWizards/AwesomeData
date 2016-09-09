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
    let cellSize = UIScreen.main.bounds.width/2 - 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unsplashImages = UnsplashImage.list() as! [UnsplashImage]
        AwesomeDataDemoAPI.fetchUnsplashImages({ (unsplashImages) in
            self.unsplashImages.removeAll()
            self.unsplashImages.append(contentsOf: unsplashImages)
            self.collectionView?.reloadData()
        }) { (message) in
            print("Error: \(message)")
        }
    }
}

// MARK: - TableViewDataSource

extension AwesomeDataDemoViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsplashImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! ImageCollectionViewCell
        
        _ = cell.setImage(unsplashImages[(indexPath as NSIndexPath).row].imageUrl(CGSize(width: cellSize, height: cellSize)), imageViewName: "pictureImageView", collectionView: collectionView, indexPath: indexPath, completion: { (image) in
            
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
}
