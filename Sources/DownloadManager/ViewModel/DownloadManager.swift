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
    var playerManager = PlayerManager()
    private var downloadManager = DownloadTask()
    @Published public var taskResult: TaskResult = .progress(0.0)
    
    //MARK: Initializer
    public init() {
        //configNotification(isRequire: true)
        downloadManager.downloadAudioCallback = { [self] result in
            DispatchQueue.main.async {
                self.taskResult = result
            }
        }
    }
    
    //MARK: downloadAudio
    public func downloadMedia(with url: String, successTitle: String = "", successSubtitle: String = "") {
        let mediaName = url.components(separatedBy: "/").last ?? ""
        downloadManager.successNotificationTitle = successTitle.isEmpty ? notificationTitle : successTitle
        downloadManager.successNotifcationSubtitle  = successSubtitle.isEmpty ? notificationDescription(mediaName) : successSubtitle
        downloadManager.downloadMedia(with: url)
    }
    
    //MARK: cancelDownload
    public func cancelDownload(with url : String, notificationTitle: String = "", notificationSubtitle: String = "") {
        let mediaName = url.components(separatedBy: "/").last ?? ""
        downloadManager.cancelNotificationTitle = notificationTitle.isEmpty ? cancelMediaTitle  : notificationTitle
        downloadManager.cancelNotificationSubtitle = notificationSubtitle.isEmpty ? cancelMediaSubtitle(mediaName) : notificationSubtitle
        downloadManager.cancelMedia()
    }
    
    //MARK: - pauseDownload
    public func pauseDownload() {
        downloadManager.pauseDownload()
    }
    
    //MARK: - resumeDownload
    public func resumeDownload() {
        downloadManager.resumeDownload()
    }
    
    // MARK: - openAudioPlayer
    public func openAudioPlayer(with url: String) -> some View {
        playerManager.deinitPlayer()
        return AudioPlayerView(mediaUrl: url)
    }
    
    public func openVideoPlayer(with url: String) {
        playerManager.deinitPlayer()
        playerManager.playVideo(url: url)
    }
    
    //MARK: - isMediaExistInDir
    // check media is already download or not
    public func isMediaExistInDir(with url : String) -> Bool {
        if let _ =  playerManager.getMeidaPath(of: url) {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - removeMediaFromDir
    public func removeMediaFromDir(with url: String) {
        downloadManager.removeMedia(with: url)
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
    
}
