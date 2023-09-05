//
//  DownloadTask.swift
//  
//
//  Created by Abhishek Pandey on 29/08/23.
//

import Foundation
import UserNotifications

public class DownloadTask: NSObject {
    
    //MARK: - Properties
    var session:URLSession?
    var dataTask:URLSessionDownloadTask?
    var mediaURL = ""
    var downloadAudioCallback: ((TaskResult) -> Void)?
    
    //MARK: Download Media
    public func downloadMedia(with url: String) {
        mediaURL = url
        if let audioUrl = URL(string: mediaURL) {
            let configuration = URLSessionConfiguration.background(withIdentifier: url)
            session = Foundation.URLSession(configuration: configuration, delegate:self, delegateQueue: OperationQueue())
            dataTask = session?.downloadTask(with: audioUrl)
            dataTask?.resume()
        } else {
            downloadAudioCallback?(.failure(invalidURL))
        }
    }
    
    //MARK: Cancel Download Media
    func cancelMedia() {
        dataTask?.cancel()
        downloadAudioCallback?(.cancel)
    }
    
}

//MARK: - URLSessionDownloadDelegate
extension DownloadTask: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession,
                           downloadTask: URLSessionDownloadTask,
                           didWriteData bytesWritten: Int64,
                           totalBytesWritten: Int64,
                           totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        downloadAudioCallback?(.progress(progress))
    }
    
    public func urlSession(_ session: URLSession,
                           downloadTask: URLSessionDownloadTask,
                           didFinishDownloadingTo location: URL) {
        saveAudioPath(with: location)
    }
}

extension DownloadTask {
    
    //MARK: -  Save Media File in DIR
    func saveAudioPath(with location: URL) {
        let documentDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        
        guard let audioUrl = URL(string: mediaURL) else { return }
        let destinationUrl = documentDirectory.appendingPathComponent(audioUrl.lastPathComponent)
        
        do {
            try FileManager.default.createDirectory(atPath: documentDirectory.path, withIntermediateDirectories: true, attributes: nil)
            
            if FileManager.default.fileExists(atPath: destinationUrl.path){
                // check this url is already exist or not
                try? FileManager.default.removeItem(at: destinationUrl)
            }
            do {
                try FileManager.default.moveItem(at: location, to: destinationUrl)
                triggerLocalNotification()
                downloadAudioCallback?(.downloaded(destinationUrl))
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            //It will return the error when unable to move the content in document directory
            downloadAudioCallback?(.failure(dirErrorMsg(error.debugDescription)))
        }
        
    }
    
    //MARK: - Remove Media
    func removeMedia(with url: String) {
        let documentDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        guard let audioUrl = URL(string: url) else { return }
        let destinationUrl = documentDirectory.appendingPathComponent(audioUrl.lastPathComponent)
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            try? FileManager.default.removeItem(at: destinationUrl)
            downloadAudioCallback?(.deleted(audioUrl))
        }
    }
}


extension DownloadTask {
    
    //MARK: - triggerLocalNotification
    func triggerLocalNotification() {
        let content = UNMutableNotificationContent()
        let mediaName = mediaURL.components(separatedBy: "/").last ?? ""
        content.title = notificationTitle
        content.subtitle = notificationDescription(mediaName)
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
