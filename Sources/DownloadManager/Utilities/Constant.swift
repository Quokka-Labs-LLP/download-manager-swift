//
//  Constant.swift
//  
//
//  Created by Abhishek Pandey on 04/09/23.
//

import Foundation
import UIKit
import AVKit


var player: AVPlayer?  // This is used for single instance of AVPlayer

let kAudioplayerImage = "playerImage"
let kBackward = "backward"
let kForward = "forward"
let kPlay = "play"
let kPause = "pause"
let kBack = "back"
let kHttp  = "http"
let kHttps = "https"

let localNotification = "NotificationStatus"

let screenHeightFactor = UIScreen.main.bounds.height / 568
let screenWidthFactor = UIScreen.main.bounds.width / 320

//MARK: Message
let successMediaTitle  = "Notification"
let cancelMediaTitle = "Notification"
let failureMediaTile = "Notification"

var successMediaSubtitle =  {(title: String) in
    return "Downloaded \(title)"
}

var cancelMediaSubtitle =  {(url: String) in
    return "Cancel \(url)!"
}

var dirErrorMsg = {(msg: String) in
    return ("Unable to create directory \(msg)")
}

let invalidURL = "Invalid URL"
let customCategoryIdentifier = "ProgressNotificationCategory"
let kNetwork = "Network Error"
let kRequestMsg = "Request timed out"
let kSpaceRealatedIssue = "Unable to retrieve free space information"
let kMediaNameError  = "Media name is nil."
