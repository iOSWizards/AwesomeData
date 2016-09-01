//
//  UIImage+Awesome.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 6/2/16.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

extension UIImage{
    
    public static func loadImage(url: String?, completion:(image: UIImage?) -> Void) -> NSURLSessionDataTask?{
        if let url = url {
            let task = AwesomeFetcher.fetchData(url, shouldCache: true) { (data) in
                if let data = data {
                    completion(image: UIImage(data: data))
                }else{
                    completion(image: nil)
                }
            }            
            return task
        }
        return nil
    }
    
}