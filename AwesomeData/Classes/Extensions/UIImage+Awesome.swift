//
//  UIImage+Awesome.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 6/2/16.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

extension UIImage{
    
    public static func loadImage(_ url: String?, completion:@escaping (_ image: UIImage?) -> Void) -> URLSessionDataTask?{
        if let url = url {
            let task = AwesomeRequester.performRequest(url, shouldCache: true) { (data) in
                if let data = data {
                    completion(UIImage(data: data))
                }else{
                    completion(nil)
                }
            }            
            return task
        }
        return nil
    }
    
}
