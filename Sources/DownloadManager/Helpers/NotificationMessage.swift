//
//  NotificationMessage.swift
//  
//
//  Created by Abhishek Pandey on 14/09/23.
//

import Foundation

public struct NotificationMessage {
    
    //MARK: Properties
    var successNotificationTitle = successMediaTitle
    var successNotifcationSubtitle = ""
    var cancelNotificationTitle = cancelMediaTitle
    var cancelNotificationSubtitle = ""
    var failureNotificationTitle = failureMediaTile
    
    //MARK: Initilizer
    public init() {}
    
    //MARK: Success Subtitle
    func successSubtitle(with name: String) -> String {
        return successNotifcationSubtitle.isEmpty ? successMediaSubtitle(name) : successNotifcationSubtitle
    }
    
    //MARK: Cancel Subtitle
    func cancelSubtitle(with name: String) -> String {
        return successNotifcationSubtitle.isEmpty ? cancelMediaSubtitle(name) : cancelNotificationSubtitle
    }
    
}
