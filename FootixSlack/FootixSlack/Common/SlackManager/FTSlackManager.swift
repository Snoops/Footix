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
    
    var chatBot: FTChatBot?
    
    /** The listeners that will receive event from this class.  Protected.  Use the addListener and removeListener methods to add and remove objects. */
    private var listeners = FTWeakReferenceMutableArray(ignoresDuplicateObjects: true)
    
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
        NSLOG("     Authenticated user   : \(client.authenticatedUser?.name)")
//        NSLOG("     Authenticated userID : \((client.authenticatedUser?.id)!)")
        
        /** Initialize FTChatBot instance */
        self.chatBot = FTChatBot(uniqueID: (self.client.authenticatedUser?.id)!, name: (self.client.authenticatedUser?.name)!)
        
    }
    
    func clientDisconnected() {}
    
    //====================================
    // MARK: - MessageEventsDelegate
    //====================================
    
    /** Called when a message is received. */
    func messageReceived(message: Message) {
        
        NSLOG("FTSlackManager | messageReceived() | Text = \(message.text!)")
        
        // Filter out messages for ChatBot
        self.filterBotMessage(message)

    }
    
    /** Called when a message is sent. */
    func messageSent(message: Message) {
        
        NSLOG("FTSlackManager | messageSent() | Text = \(message.text!)")
        
    }
    
    /** Called when a message is edited. */
    func messageChanged(message: Message) {}
    
    /** Called when a message is deletec. */
    func messageDeleted(message: Message?) {}
    
    //====================================
    // MARK: - Send Response
    //====================================
    
    func sendResponse(response: Message) {
        
        self.client.sendMessage(response.text!, channelID: response.channel!)
        
    }
    
    //====================================
    // MARK: - Filter and Dispatch
    //====================================
    
    func filterBotMessage(message: Message) {
        
        // Look for occurences of chatBot uniqueID in received message.
        
        NSLOG("FTSlackManager | filterBotMessage() | Message Bot: \(message.user!)")
        NSLOG("FTSlackManager | filterBotMessage() | Chat Bot unique ID: \(self.chatBot!.uniqueID!)")
        
        if message.user != self.chatBot?.uniqueID {
            
            //if message.text!.rangeOfString((self.chatBot?.uniqueID)!) != nil {
            
                // Message was destined to ChatBot, so dispatch it to listeners.
                self.dispatchMessageToListeners(message)
            //}
            
        }

    }
    
    func dispatchMessageToListeners(message: Message) {
        
        // Loop Backwards through all of the objects and call the event.  Remove the object if it has been released.
        for var i:Int = (self.listeners.count - 1); i >= 0; i-- {
            
            //Get the object at the index
            let listener:FTSlackManagerListener? = self.listeners.objectAtIndex(i) as? FTSlackManagerListener
            
            //If the observer has been released, remove it from the index
            if listener == nil {
                self.listeners.removeObjectAtIndex(i)
                continue
            }
            
            //Call the status change event in the observer
            listener!.slackManager(self, didReceiveMessage: message)
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
    
    //====================================
    // MARK: - Add / Remove Listeners
    //====================================
    
    func addListener(listener:FTSlackManagerListener) {
        
        let listenerAsObject:NSObject? = listener as? NSObject
        assert(listenerAsObject != nil, "FTSlackManagerListener | addListener | ERROR: listener must be of type NSObject.")
        self.listeners.addObject(listenerAsObject!)
        
    }
    
    func removeListener(listener:FTSlackManagerListener) {
        
        let listenerAsObject:NSObject? = listener as? NSObject
        assert(listenerAsObject != nil, "FTSlackManagerListener | removeListener | ERROR: listener must be of type NSObject.")
        self.listeners.removeObject(listenerAsObject!)
        
    }

}
