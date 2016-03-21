//
//  String+Extensions.swift
//  FootixSlack
//
//  Created by Adrien Caranta on 2016-03-18.
//  Copyright © 2016 Footix. All rights reserved.
//

import Foundation

extension String {
    
    func cleanString() -> String {
        
        let stringToClean = self
        
        NSLOG("String+Extensions | clean() | stringToClean:'\(stringToClean)'")
        
        return stringToClean
    }
    
    func isPunctuation() -> Bool {
        
        let ponctuationCharacters: [String] = ["?", "!", ".", ";", ",", ":"]
        
        for char in ponctuationCharacters {
            
            if self == char {
                return true
            }
        }

        return false
    }
    
    func trimLeft() -> String {
        
        return ""
    }
    
    func trimRight() -> String {
        
        return ""
    }
    
    func trimLeftAndRight() -> String {
        
        return ""
    }
    
}
