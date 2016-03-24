//
//  FuzzySearch.swift
//  FootixSlack
//
//  Created by Adrien CARANTA on 2016-03-20.
//  Copyright © 2016 Footix. All rights reserved.
//

import Foundation

class FTFuzzySearch {
    
    /* The FuzzySearch.search method returns a Boolean of TRUE if the stringToSearch for is found in the originalString otherwise FALSE. Not case sensitive.
    - parameter originalString: The original contents that is going to be searched
    - parameter stringToSearch: The specific contents to search for
    - return: A Boolean of TRUE if found otherwise FALSE for not found
    */
    static func search<T : Equatable>(originalString originalString: T, stringToSearch: T) -> Bool {
        return search(originalString: originalString, stringToSearch: stringToSearch, isCaseSensitive: false)
    }
    
    /* The FuzzySearch.search method returns the number of times found (Integer) of the set of characters to be searched within the original character set.
    - parameter originalString: The original contents that is going to be searched.
    - parameter stringToSearch: The specific contents to search for.
    - return: An Integer of the number of occurences of the set of characters to be searched.
    */
    static func search<T : Equatable>(originalString originalString: T, stringToSearch: T) -> Int {
        return search(originalString: originalString, stringToSearch: stringToSearch, isCaseSensitive: false)
    }
    
    /* The FuzzySearch.search method returns a Boolean of TRUE if the stringToSearch for is found in the originalString otherwise FALSE. This search is case sensitive.
    - parameter originalString: The original contents that is going to be searched.
    - parameter stringToSearch: The specific contents to search for.
    - parameter isCaseSensitive: A Boolean value to indicate whether to use case sensitive or case insensitive search parameters.
    - return: A Boolean of TRUE if found otherwise FALSE for not found.
    */
    static func search<T : Equatable>(originalString originalString: T, stringToSearch: T, isCaseSensitive: Bool) -> Bool {
        
        // Decipher if the String to be searched for is found
        let searchCount:Int = search(originalString: originalString, stringToSearch: stringToSearch, isCaseSensitive: isCaseSensitive)
        
        if searchCount > 0 {
            return true
        } else {
            return false
        }
        
    }
    
    /* The FuzzySearch.search method returns the number of instances a specific character set is found with in a String object.
    - parameter originalString: The original contents that is going to be searched.
    - parameter stringToSearch: The specific contents to search for.
    - parameter isCaseSensitive: A Boolean value to indicate whether to use case sensitive or case insensitive search parameters.
    - return: An Integer value of the number of instances a character set matches a String.
    */
    static func search<T : Equatable>(originalString originalString: T, stringToSearch: T, isCaseSensitive: Bool) -> Int {
        
        var tempOriginalString = String()
        var tempStringToSearch = String()
        
        // Verify that the variables are Strings
        if originalString is String && stringToSearch is String {
            tempOriginalString = originalString as! String
            tempStringToSearch = stringToSearch as! String
        } else {
            return 0
        }
        
        // Either String is empty return false
        if tempOriginalString.characters.count == 0 || tempStringToSearch.characters.count == 0 {
            return 0
        }
        
//        // stringToSearch is greater than the originalString return false
//        if tempOriginalString.characters.count < tempStringToSearch.characters.count {
//            return 0
//        }
        
        // Check isCaseSensitive if true lowercase the contents of both strings
        if !isCaseSensitive {
            tempOriginalString = tempOriginalString.lowercaseString
            tempStringToSearch = tempStringToSearch.lowercaseString
        }
        
        var searchIndex : Int = 0
        var searchCount : Int = 0
        
        // Search the contents of the originalString to determine if the stringToSearch can be found or not
        for charOut in tempOriginalString.characters {
            
            for (indexIn, charIn) in tempStringToSearch.characters.enumerate() {
                
                if indexIn == searchIndex {
                    
                    if charOut==charIn {
                        
                        searchIndex++
                        
                        if searchIndex == tempStringToSearch.characters.count {
                            searchCount++
                            searchIndex = 0
                        } else {
                            break
                        }
                        
                    } else {
                        break
                    }
                }
            }
        }
        
        return searchCount
    }
    
    /* The FuzzySearch.search method returns the Array of String(s) a specific character approximately matches that String object.
    - parameter originalString: The original contents that is going to be searched.
    - parameter stringToSearch: The specific contents to search for.
    - parameter isCaseSensitive: A Boolean value to indicate whether to use case sensitive or case insensitive search parameters.
    - return: The Array of String(s) if any are found otherwise an empty Array of String(s).
    */
    static func search(var originalString originalString: String, var stringToSearch: String, isCaseSensitive: Bool) -> [String] {
        
        // Either String is empty return false
        if originalString.characters.count == 0 || stringToSearch.characters.count == 0 {
            return [String]()
        }
        
//        // stringToSearch is greater than the originalString return false
//        if originalString.characters.count < stringToSearch.characters.count {
//            return [String]()
//        }
        
        // Check isCaseSensitive if true lowercase the contents of both strings
        if !isCaseSensitive {
            originalString = originalString.lowercaseString
            stringToSearch = stringToSearch.lowercaseString
        }
        
        var searchIndex : Int = 0
        var approximateMatch:Array = [String]()

        // Search the contents of the originalString to determine if the stringToSearch can be found or not
        for content in originalString.componentsSeparatedByString(" ") {
            
            for charOut in content.characters {
                
                for (indexIn, charIn) in stringToSearch.characters.enumerate() {
                    
                    if indexIn == searchIndex {
                        
                        if charOut==charIn {
                            
                            searchIndex++
                            
                            if searchIndex==stringToSearch.characters.count {
                                approximateMatch.append(content)
                                searchIndex = 0
                            } else {
                                break
                            }
                            
                        } else {
                            break
                        }
                    }
                }
            }
        }
        
        return approximateMatch
    }
    
    /* The score method that provides fast fuzzy string matching and scoring based
    on the technique of finding strings that match a pattern approximately
    (rather than exactly). The problem of approximate string matching is typically
    dived into two sub-problems: finding approximate substring matches inside
    a given string and finding dictionary strings that match the pattern approximately.
    
    The design and implementation of this method are based on
    StringScore_Swift by (Yichi Zhang) and StringScore in Javascript (Joshaven Potter)
    
    - parameter originalString: The original contents that is going to be searched.
    - parameter stringToSearch: The specific contents to search for.
    - parameter fuzziness: Double value to indicate a function of distance between two words,which provides a measure of their similarity. Default value is 0.
    - return: The score value of the approximate match between strings. Score of 0 for no match; up to 1 for perfect match.
    */
    static func score(originalString originalString: String, stringToMatch: String, fuzziness: Double? = nil) -> Double {
        
        // Either String objects are empty return score of 0
        if originalString.isEmpty || stringToMatch.isEmpty {
            return 0
        }

        // Either String objects are the same return score of 1
        if originalString == stringToMatch {
            return 1
        }
        
        // Initialization of the local variables
        var runningScore = 0.0
        var charScore = 0.0
        var finalScore = 0.0
        let lowercaseString = originalString.lowercaseString
        let strLength = originalString.characters.count
        let lowercaseStringToMatch = stringToMatch.lowercaseString
        let wordLength = stringToMatch.characters.count
        var indexOfString:String.Index!
        var startAt = lowercaseString.startIndex
        var fuzzies = 1.0
        var fuzzyFactor = 0.0
        var fuzzinessIsNil = true
        
        // Cache fuzzyFactor for speed increase
        if let fuzziness = fuzziness {
            fuzzyFactor = 1 - fuzziness
            fuzzinessIsNil = false
        }
        
        for i in 0..<wordLength {
            
            // Find next first case-insensitive match of word's i-th character.
            // The search in "string" begins at "startAt".
            if let range = lowercaseString.rangeOfString(String(lowercaseStringToMatch[lowercaseStringToMatch.startIndex.advancedBy(i)]), options: NSStringCompareOptions.CaseInsensitiveSearch, range: Range<String.Index>( start: startAt, end: lowercaseString.endIndex), locale: nil) {
                
                // start index of word's i-th character in string.
                indexOfString = range.startIndex
                
                if startAt == indexOfString {
                    // Consecutive letter & start-of-string Bonus
                    charScore = 0.7
                } else {
                    charScore = 0.1
                    /*
                    Acronym Bonus
                    Weighing Logic: Typing the first character of an acronym is as if you
                    preceded it with two perfect character matches.
                    */
                    if originalString[indexOfString.advancedBy(-1)] == " " { charScore += 0.8}
                }
                
            } else {
                // Character not found.
                if fuzzinessIsNil {
                    // Fuzziness is nil. Return 0.
                    return 0
                } else {
                    fuzzies += fuzzyFactor
                    continue
                }
            }
            
            // Same case bonus.
            if (originalString[indexOfString] == stringToMatch[stringToMatch.startIndex.advancedBy(i)]) {
                charScore += 0.1
            }
            
            // Update scores and startAt position for next round of indexOf.
            runningScore += charScore
            startAt = indexOfString.advancedBy(1)
        }
        
        // Reduce penalty for longer strings.
        finalScore = 0.5 * (runningScore / Double(strLength) + runningScore / Double(wordLength)) / fuzzies
        
        if (lowercaseString[lowercaseString.startIndex] == lowercaseString[lowercaseString.startIndex]) && (finalScore < 0.85) {
            finalScore += 0.15
        }
        
        return finalScore
    }
    
}


    