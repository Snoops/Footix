//
//  FTSlackManager.swift
//  FootixSlack
//
//  Created by Adrien CARANTA on 2016-03-17.
//  Copyright © 2016 Footix. All rights reserved.
//

import Cocoa
import SlackKit

class FTSlackManager: NSObject, MessageEventsDelegate, SlackEventsDelegate {
    
    //====================================
    // MARK: - Properties
    //====================================
    
    /** Shared instance */
    static let sharedManager = FTSlackManager()
    
    /** Instance of SlackKit Client */
    let client:Client = Client(apiToken: Constants.FTSlackClient.token)
    
    //====================================
    // MARK: - Constructor
    //====================================
    
    override init() {
        
        // Call the base
        super.init()
        
        // Connects the client and sets delegates
        self.client.connect()
        self.client.slackEventsDelegate = self
        self.client.messageEventsDelegate = self
        
    }
    
    //====================================
    // MARK: - SlackClientDelegate
    //====================================
    
    func clientConnected() {
        
        NSLOG("FTSlackManager | clientConnected()")
        NSLOG("     Team : \((client.team?.name)!)")
        NSLOG("     Authenticated user : \((client.authenticatedUser?.name)!)")
        
        for userDict in self.client.users as [String : User] {
            NSLOG("     Bots : \(userDict)")
            NSLOG("==================================================")
        }
    }
    
    func clientDisconnected() {}
    
    //====================================
    // MARK: - MessageEventsDelegate
    //====================================
    
    func messageReceived(message: Message) {
        
        NSLOG("FTSlackManager | messageReceived()")
        NSLOG("     Text = \(message.text!)")
        NSLOG("     User = \(message.user!)")
        NSLOG("     Channel = \(message.channel!)")
        
        self.client.sendMessage("I'm great, thank you!", channelID: (message.channel!))
        
    }
    
    func messageSent(message: Message) {
        
        NSLOG("FTSlackManager | messageSent() | Text = \(message.text!)")
        
    }
    
    func messageChanged(message: Message) {
        
        NSLOG("FTSlackManager | messageChanged() | Text = \(message.text!)")
        
    }
    
    func messageDeleted(message: Message?) {
        
        if let actualMessage = message {
            NSLOG("FTSlackManager | messageDeleted() | Text = \(actualMessage.text!)")
        }
        
    }
    
    //====================================
    // MARK: - SlackEventsDelegate
    //====================================
    
    func preferenceChanged(preference: String, value: AnyObject) {}
    
    func userChanged(user: User) {}
    
    func presenceChanged(user: User?, presence: String?) {}
    
    func manualPresenceChanged(user: User?, presence: String?) {}
    
    func botEvent(bot: Bot) {}

}
