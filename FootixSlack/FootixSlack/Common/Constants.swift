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
        
        //If debug mode is on or not.
        static let debugModeOn:Bool = true
        
    }
    
    struct SlackClient {
        
        // Authentication token
        static let token: String = "xoxb-26175293891-3l4kYku020nxtGQ6DvhyNH1o"
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
