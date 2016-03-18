//
//  FTSlackManagerListener.swift
//  FootixSlack
//
//  Created by Adrien Caranta on 2016-03-18.
//  Copyright © 2016 Footix. All rights reserved.
//

import Foundation
import SlackKit

protocol FTSlackManagerListener {
    
    /** Called when the FTSlackManager receives a message destined to our bot.
     - parameter manager: The manager that has triggered the event
     - parameter message: The message that should be handled
    */
    func slackManager(manager: FTSlackManager, didReceiveMessage message: Message)
    
    /** Called when the FTSlackManager sends a response message.
     - parameter manager: The manager that has triggered the event
     - parameter message: The message that was sent as a response.
     */
    func slackManager(manager: FTSlackManager, didSendResponseMessage message: Message)
    
}