//
//  AttributedStringExtension.swift
//  CollectIt
//
//  Created by Kathryn Whelan on 4/15/21.
//

import Foundation


extension NSAttributedString {
    
    static func addHyperlink(for path : String, in string : String, as substring : String) -> NSAttributedString {
        
        let nsString = NSString(string: string)
        let subStringRange = nsString.range(of: substring)
        let attribString = NSMutableAttributedString(string: string)
        attribString.addAttribute(.link, value: path, range: subStringRange)
        return attribString
    }
    
    static func removeHyperlink(in string : String, as substring : String) -> NSAttributedString {
        
        let nsString = NSString(string: string)
        let subStringRange = nsString.range(of: substring)
        let attribString = NSMutableAttributedString(string: string)
        attribString.removeAttribute(.link, range: subStringRange)
        return attribString
    }  
}
