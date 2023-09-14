//
//  File.swift
//  
//
//  Created by Abhishek Pandey on 14/09/23.
//

import Foundation

public struct NotificationMessage {
    var successNotificationTitle = successMediaTitle
    var successNotifcationSubtitle = ""
    var cancelNotificationTitle = cancelMediaTitle
    var cancelNotificationSubtitle = ""
    var failureNotificationTitle = failureMediaTile
    
    public init() {}
    func successSubtitle(with name: String) -> String {
        return successNotifcationSubtitle.isEmpty ? successMediaSubtitle(name) : successNotifcationSubtitle
    }
    
    func cancelSubtitle(with name: String) -> String {
        return successNotifcationSubtitle.isEmpty ? cancelMediaSubtitle(name) : cancelNotificationSubtitle
    }
    
}
