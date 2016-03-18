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

    /** ChatBot unique ID */
    private(set) var uniqueID:String? = nil
    
    /** ChatBot name */
    private(set) var name:String? = nil

    //===========================
    // MARK: Constructor
    //===========================
    
    required init(uniqueID:String, name: String) {
        //Call the base
        super.init()
        
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
    // MARK: - FTSlackManagerListener
    //====================================
    
    func slackManager(manager: FTSlackManager, didReceiveMessage message: Message) {
        
        NSLOG("FTBot | didReceiveMessage | Text: \(message.text!)")
        
    }
    
}
