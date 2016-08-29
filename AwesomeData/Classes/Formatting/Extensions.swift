//
//  Extensions.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 16/08/2016.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

extension NSData {
    var attributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options:[
                NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
                ], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension String {
    var utf8Data: NSData? {
        return dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    var stripHTML: String? {
        return stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
    }
}

extension NSAttributedString {
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.max, height: height)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}