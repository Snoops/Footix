//
//  FTBot.swift
//  FootixSlack
//
//  Created by Adrien CARANTA on 2016-03-17.
//  Copyright © 2016 Footix. All rights reserved.
//

import Cocoa
import SlackKit

class FTChatBot: NSObject, FTSlackManagerListener {
    
    //===========================
    // MARK: Properties
    //===========================

    /** ChatBot unique ID. */
    private(set) var uniqueID:String? = nil
    
    /** ChatBot name. */
    private(set) var name:String? = nil
    
    /** Temporary test knowledge base. Dictionary of questions/answers. */
    private var knowledgeBase: [String : String] = ["HOW ARE YOU": "I'M GREAT THANK YOU!",
                                                    "WHATS YOUR NAME": "MY NAME IS @FOOTIX",
                                                    "WHAT ARE YOU": "I'M A BOT",
                                                    "ARE YOU INTELLIGENT": "OF COURSE!",
                                                    "BYE": "IT WAS NICE TALKING TO YOU, SEE YOU NEXT TIME!",
                                                    "QUEL EST LE CLASSEMENT DE LA LIGUE 1": "ALLEZ L'OM",
                                                    "QUEL EST LE CLASSEMENT DE LA LIGUE 2": "ALLEZ L'OM, CHAMPION D'EUROPE"]
    
    /** */
    private var previousInputMessage: Message? = nil
    
    /** */
    private var previousOutputMessage: Message? = nil
    
    /** Message received by FTSlackManager and destined to the chatBot. */
    private var inputMessage: Message? = nil {
        didSet {
            // Try to find a match for the input message.
            self.outputMessage = self.findMatch(self.inputMessage!)
            
            // Save last input.
            self.previousInputMessage = self.inputMessage
        }
    }
    
    /** Response message to be sent as a reply. */
    private var outputMessage: Message? = nil {
        didSet {
            // When a match is found send the response message to user.
            self.sendResponseMessage(self.outputMessage!)
            
            // Save last output
            self.previousOutputMessage = self.outputMessage
        }
    }
    
    //===========================
    // MARK: Constructor
    //===========================
    
    required init(uniqueID:String, name: String) {
        //Call the base
        super.init()
        
        // Set properties
        self.uniqueID = uniqueID
        self.name = name
        
        //Add self as a delegate to slack manager listener
        FTSlackManager.sharedManager.addListener(self)
    }
    
    deinit {
        //Remove self as a delegate to slack manager listener
        FTSlackManager.sharedManager.removeListener(self)
    }
    
    //====================================
    // MARK: - Finding Match
    //====================================
    
    /** Called when an input message is received to find a corresponding match in the knowledge base.
    - parameter message: The input message to compare against knowledge base.
    - return: The response message that needs to be sent as response to user.
    */
    func findMatch(message: Message) -> Message {
        
        NSLOG("FTChatBot | findMatch()")
        
        // Clean input message before searching for a response.
        let inputText: String = self.cleanString(message.text!)
        
        // If the string end up being empty after cleaning, the return default message.
        if inputText.isEmpty == true {
            return Message(message: ["text": Constants.ChatBot.defaultEmptyStringResponse, "channel": message.channel!])!
        }
        
        // Check that new incoming message is different from previous input message.
        if self.previousInputMessage != nil && inputText == self.previousInputMessage?.text! {
            return Message(message: ["text": Constants.ChatBot.defaultRepeatQuestionResponse, "channel": message.channel!])!
        }
        
        // Check that new incoming message is different from previous output message.
        if self.previousOutputMessage != nil && inputText == self.previousOutputMessage?.text! {
            return Message(message: ["text": Constants.ChatBot.defaultRepeatAnswerResponse, "channel": message.channel!])!
        }
        
        /** Store scores for best approximate match. */
        var scoreDictionay: [Double: String] = [Double: String]()
        
        // Loop through knowledge base dictionary
        for (question, answer) in self.knowledgeBase {
            
            // If we find a perfect match.
            if FTFuzzySearch.search(originalString: question, stringToSearch: inputText, isCaseSensitive: false) == true {
                
                NSLOG("     FTChatBot | findMatch() | Match found!")
                NSLOG("         FTChatBot | findMatch() | Question: \(question) | Answer: \(answer)")
                
                // We create a response message with text answer from knowledge base.
                return Message(message: ["text": answer, "channel": message.channel!])!
                
            } else { // Else, we try to find the best approximate match.
                
                NSLOG("     FTChatBot | findMatch() | No match found!")

                // Find score for each DB entry
                let fuzzySearchScore: Double = FTFuzzySearch.score(originalString: question, stringToMatch: inputText, fuzziness: 1.0)
                
                // Store scores in dictionary
                scoreDictionay[fuzzySearchScore] = question
                
                NSLOG("         FTChatBot | findMatch() | Score: \(fuzzySearchScore) | Question: \(question)")
                
            }
        }
            
        NSLOG("FTChatBot | No match found | ScoreDict: \(scoreDictionay)")
        
        // Order score keys. Best score should be the first element.
        let sortedKeys = scoreDictionay.keys.sort(>)
        
        NSLOG("FTChatBot | No match found | Best Score: \(sortedKeys)")
        
        // Check if first element's score is better than 0.
        if sortedKeys.first > 0.0 {
            
            // Return best approximate match.
            let messageToReturn = self.knowledgeBase[scoreDictionay[sortedKeys.first!]!]!
            return Message(message: ["text": messageToReturn, "channel": message.channel!])!
                
        } else { // Else return 'default unknow answer' response.
                
            // We create a response message with text answer from knowledge base.
            return Message(message: ["text": Constants.ChatBot.defaultUnknownResponse, "channel": message.channel!])!
        }
    }
    
    //====================================
    // MARK: - Sending Response
    //====================================
    
    /** Called when a response match is found for the input message.
    - parameter response: The response message to send back to the user.
    */
    func sendResponseMessage(response: Message) {
        
        NSLOG("FTChatBot | sendResponseMessage() | Response: \(response.text!)")
        
        // FTSlackManager sends response back to slack channel.
        FTSlackManager.sharedManager.sendResponse(response)
    }
    
    //====================================
    // MARK: - Clean String
    //====================================
    
    func cleanString(stringToClean: String) -> String {
        
        NSLOG("FTChatBot | clean() | StringToClean: \(stringToClean)")
    
        // Remove occurences of black listed words in string.
        var stc = stringToClean
        for string in Constants.ChatBot.blackListedWords {
            stc = stc.stringByReplacingOccurrencesOfString(string, withString: "")
        }

        var cleanedString: String = ""
        var previousCharacter: String? = nil
        
        var stringLength = stc.characters.count
        
        // Loop through string's characters set.
        for var i = 0; i < stringLength; i++ {
            
            // If space 
            if stc[i] == " " && previousCharacter == " " {
                continue
            } else if self.isPunctuation(stc[i]) == false {
                cleanedString.append(stc[i])
            }
            
            previousCharacter = stc[i]
        }
        
        
        // *********************************************************
        // TODO: TO BE IMPROVED
        // Decided to do another round to eliminate extra spaces.
        stc = cleanedString
        stringLength = stc.characters.count
        cleanedString = ""
        
        for var i = 0; i < stringLength; i++ {
            
            // If space
            if stc[i] == " " && previousCharacter == " " {
                continue
            } else if self.isPunctuation(stc[i]) == false {
                cleanedString.append(stc[i])
            }
            
            previousCharacter = stc[i]
        }
        // *********************************************************
        
        
        NSLOG("FTChatBot | clean() | Cleaned String: \(cleanedString)")
        
        return cleanedString
    }
    
    func isPunctuation(char:String) -> Bool {
                
        let ponctuationCharacters: [String] = ["?", "!", ".", ";", ",", ":"]
        
        for punctuationChar in ponctuationCharacters {
            
            if char == punctuationChar {
                return true
            }
        }
        
        return false
    }
    
    //====================================
    // MARK: - FTSlackManagerListener
    //====================================
    
    /** Called when the FTSlackManager receives a message destined to our bot.
    - parameter manager: The manager that has triggered the event
    - parameter message: The message that should be handled
    */
    func slackManager(manager: FTSlackManager, didReceiveMessage message: Message) {
        
        NSLOG("FTBot | didReceiveMessage | Text: \(message.text!)")
        
        // Set incoming message as our inputMessage
        self.inputMessage = message
    }
    
    /** Called when the FTSlackManager sends a response message.
     - parameter manager: The manager that has triggered the event
     - parameter message: The message that was sent as a response.
    */
    func slackManager(manager: FTSlackManager, didSendResponseMessage message: Message) {
        
        NSLOG("FTBot | didSendResponseMessage | Text: \(message.text!)")
    }
    
}










