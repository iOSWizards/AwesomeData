//
//  Extensions.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 16/08/2016.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

extension Data {
    public var attributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options:[
                NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension String {
    public var utf8Data: Data? {
        return data(using: String.Encoding.utf8)
    }
    
    public var stripHTML: String? {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

extension NSAttributedString {
    public func heightWithConstrainedWidth(_ width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    public func widthWithConstrainedHeight(_ height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}
