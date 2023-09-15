//
//  DownloadManager.swift
//
//
//  Created by Abhishek Pandey on 29/08/23.
//

import Foundation
import SwiftUI

public class DownloadManager: ObservableObject {
    
    //MARK: - Properties
    let playerManager: PlayerManager
    private var downloadTask: DownloadTask
    var notificationMessage: NotificationMessage
    var service = Services()
    private var audioName = ""
    @Published public var taskResult: TaskResult = .progress(0.0)
    
    //MARK: Initializer
    /// It initializes the properties and sets up the download task callback.
    public init(notificationMessage: NotificationMessage) {
        self.notificationMessage = notificationMessage
        self.downloadTask = service.getDownloadTask()
        self.playerManager = service.getPlayerManager()
        downloadTask.downloadAudioCallback = { [self] result in
            DispatchQueue.main.async {
                self.taskResult = result
                self.callNotification(with: self.taskResult)
            }
        }
    }
    
    //MARK: DownloadAudio
    /// Download the media from the url
    public func downloadMedia(with url: String) {
        if let mediaName = url.components(separatedBy: "/").last {
            audioName = mediaName
        } else {
            debugPrint(kMediaNameError)
        }
        downloadTask.downloadMedia(with: url)
    }
    
    //MARK: CancelDownload
    /// Cancel downloading task of media
    public func cancelDownload(with url : String) {
        if let mediaName = url.components(separatedBy: "/").last {
            audioName = mediaName
        } else {
            debugPrint(kMediaNameError)
        }
        downloadTask.cancelMedia()
    }
    
    //MARK: - PauseDownload
    /// Pause downloading task of media
    public func pauseDownload() {
        downloadTask.pauseDownload()
    }
    
    //MARK: - ResumeDownload
    ///Resume downloading task of media
    public func resumeDownload() {
        downloadTask.resumeDownload()
    }
    
    //MARK: - Is Media Exist In Directory
    ///Check media is already download or not
    public func isMediaExistInDir(with url : String) -> Bool {
        return (playerManager.getMediaPath(of: url) != nil) ? true : false
    }
    
    //MARK: - Remove Media From Directory
    ///Remove media from a document directory with the local url
    public func removeMediaFromDir(with url: String) {
        downloadTask.removeMedia(with: url)
    }
    
    //MARK: LocalNotification Configuration
    ///Local notification requirement will set with true or false
    public func notificationConfiguration(isRequire: Bool) {
        UserDefaults.standard.set(isRequire, forKey: localNotification)
    }
    
    //MARK: isNotificationEnable
    ///Get notification status: is't enable or not?
    public func isNotificationEnable() -> Bool {
        return UserDefaults.standard.bool(forKey: localNotification)
    }
    
    //MARK: callNotification
    private func callNotification(with taskResultType: TaskResult) {
        switch taskResultType {
        case .downloaded:
            /// call when download task is completed
            triggerLocalNotification(title: notificationMessage.successNotificationTitle, subtitle: notificationMessage.successSubtitle(with: audioName))
        case .progress:
            break
        case .failure(let message):
            /// call when get an error during download task
            triggerLocalNotification(title: notificationMessage.failureNotificationTitle, subtitle: message)
        case .cancel:
            /// call when cancel the downloading task
            triggerLocalNotification(title: notificationMessage.cancelNotificationTitle, subtitle: notificationMessage.cancelSubtitle(with: audioName))
        case .deleted:
            break
        }
    }
}

extension DownloadManager {
    
    //MARK: - TriggerLocalNotification
    /// this is used for show notification in foreground or background during url session download task status
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
