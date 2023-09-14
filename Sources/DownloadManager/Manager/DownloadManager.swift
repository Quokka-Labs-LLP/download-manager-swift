//
//  DownloadManager.swift
//
//
//  Created by Abhishek Pandey on 29/08/23.
//

import Foundation
import SwiftUI

public class DownloadManager: ObservableObject {
    
    //MARK: - properties
    let playerManager = PlayerManager()
    private var downloadTask = DownloadTask()
    var notificationMessage: NotificationMessage
    private var audioName = ""
    @Published public var taskResult: TaskResult = .progress(0.0)
    
    //MARK: Initializer
    public init(notificationMessage: NotificationMessage) {
        self.notificationMessage = notificationMessage
        downloadTask.downloadAudioCallback = { [self] result in
            DispatchQueue.main.async {
                self.taskResult = result
                self.callNotification(with: self.taskResult)
            }
        }
        
    }
    
    //MARK: downloadAudio
    public func downloadMedia(with url: String, successTitle: String = "", successSubtitle: String = "") {
        if let mediaName = url.components(separatedBy: "/").last {
            audioName = mediaName
        } else {
            debugPrint(kMediaNameError)
        }
        downloadTask.downloadMedia(with: url)
    }
    
    //MARK: cancelDownload
    public func cancelDownload(with url : String, notificationTitle: String = "", notificationSubtitle: String = "") {
        if let mediaName = url.components(separatedBy: "/").last {
            audioName = mediaName
        } else {
            debugPrint(kMediaNameError)
        }
        downloadTask.cancelMedia()
        
    }
    
    //MARK: - pauseDownload
    public func pauseDownload() {
        downloadTask.pauseDownload()
    }
    
    //MARK: - resumeDownload
    public func resumeDownload() {
        downloadTask.resumeDownload()
    }
    
    
    
    //MARK: - isMediaExistInDir
    // check media is already download or not
    public func isMediaExistInDir(with url : String) -> Bool {
        if (playerManager.getMediaPath(of: url) != nil) {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - removeMediaFromDir
    public func removeMediaFromDir(with url: String) {
        downloadTask.removeMedia(with: url)
    }
    
    //MARK: Config toggle LocalNotification
    // user can set the notification requirement
    public func configNotification(isRequire: Bool) {
        UserDefaults.standard.set(isRequire, forKey: localNotification)
    }
    
    //MARK: isNotificationEnable
    //Get notification status: is't enable or not?
    public func isNotificationEnable() -> Bool {
        return UserDefaults.standard.bool(forKey: localNotification)
    }
    
    //MARK: callNotification
    private func callNotification(with taskResultType: TaskResult) {
        switch taskResultType {
        case .downloaded:
            triggerLocalNotification(title: notificationMessage.successNotificationTitle, subtitle: notificationMessage.successSubtitle(with: audioName))
        case .progress:
            break
        case .failure(let message):
            triggerLocalNotification(title: notificationMessage.failureNotificationTitle, subtitle: message)
        case .cancel:
            triggerLocalNotification(title: notificationMessage.cancelNotificationTitle, subtitle: notificationMessage.cancelSubtitle(with: audioName))
        case .deleted:
            break
        }
    }
    
}

extension DownloadManager {
    
    //MARK: - triggerLocalNotification
    func triggerLocalNotification(title: String, subtitle: String) {
        if isNotificationEnable() {
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = subtitle
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
}
