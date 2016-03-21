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
        
        let stringToClean: String = self
        
        NSLOG("String+Extensions | clean() | stringToClean:'\(stringToClean)'")
        
        var characters = self.characters.map { String($0) }
        
        for var i = 0; i < characters.count; i++ {
            
            let char: String = characters[i]
            
            if char.isPunctuation() == true {
                characters.removeAtIndex(i)
            }
        }
        
//        stringToClean = stringToClean.stringByReplacingOccurrencesOfString(<#T##target: String##String#>, withString: <#T##String#>)
        
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
