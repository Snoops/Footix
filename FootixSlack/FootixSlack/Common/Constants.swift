//
//  Constants.swift
//  FootixSlack
//
//  Created by Adrien CARANTA on 2016-03-17.
//  Copyright © 2016 Footix. All rights reserved.
//

import Foundation

struct Constants {
    
    struct AppSettings {
        
        /** If debug mode is on or not. */
        static let debugModeOn:Bool = true
        
    }
    
    struct SlackClient {
        
        /** Authentication token */
        static let token: String = "xoxb-26175293891-3l4kYku020nxtGQ6DvhyNH1o"
        
    }
    
    struct ChatBot {
        
        /** List of keywords to remove from an input text. */
        static let blackListedWords: [String] = ["hey", "<@U0S558MS7>"]
            
        /** Default value when bot doesn't know the answer. */
        static let defaultUnknownResponse:String = "I'M NOT SURE IF I UNDERSTAND WHAT YOU ARE TALKING ABOUT."
            
        /** Default value when bot has to answer to an empty string. */
        static let defaultEmptyStringResponse:String = "SORRY, I WAS FALLING ASLEEP! WAHT'S UP?"
            
        /** Default value when user make bot repeat itself. */
        static let defaultRepeatQuestionResponse:String = "ARE YOU REALLY MAKING ME REPEAT MYSELF??"
            
        /** Default value when user repeats bot's answer. */
        static let defaultRepeatAnswerResponse: String = "ARE YOU MOCKING ME?"
        
    }

}

//====================================
//MARK: Log Macros
//====================================

/** Logs to console only.  And only if debug mode is on. */
func NSLOG(message: String){
    if Constants.AppSettings.debugModeOn == false { return }
    NSLog(message)
}
