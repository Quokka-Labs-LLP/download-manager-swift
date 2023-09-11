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
    var mediaName = ""
    var downloadAudioCallback: ((TaskResult) -> Void)?
    var successNotificationTitle = ""
    var successNotifcationSubtitle = ""
    var cancelNotificationTitle = ""
    var cancelNotificationSubtitle = ""
    
    //var downloManager = DownloadManager()
    
    //MARK: Download Media
    public func downloadMedia(with url: String) {
        mediaURL = url
        mediaName = mediaURL.components(separatedBy: "/").last ?? ""
        if let audioUrl = URL(string: mediaURL) {
            let configuration = URLSessionConfiguration.background(withIdentifier: url)
            session = Foundation.URLSession(configuration: configuration, delegate:self, delegateQueue: OperationQueue())
            dataTask = session?.downloadTask(with: audioUrl)
            dataTask?.resume()
        } else {
            downloadAudioCallback?(.failure(invalidURL))
            triggerLocalNotification(title: failure, subtitle: invalidURL)
        }
    }
    
    //MARK: Cancel Download Media
    func cancelMedia() {
        dataTask?.cancel()
        downloadAudioCallback?(.cancel)
        triggerLocalNotification(title: cancelNotificationTitle, subtitle: cancelNotificationSubtitle)
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
        // triggerProgressNotification(progress: progress)
    }
    
    public func urlSession(_ session: URLSession,
                           downloadTask: URLSessionDownloadTask,
                           didFinishDownloadingTo location: URL) {
        saveAudioPath(with: location)
    }

    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        downloadAudioCallback?(.failure(error?.localizedDescription ?? kNetwork))
        triggerLocalNotification(title: failure, subtitle: (error?.localizedDescription ?? kNetwork))
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            if let error = error {
                if let nsError = error as NSError?, nsError.domain == NSURLErrorDomain {
                    // Check the error code to determine the specific network error
                    switch nsError.code {
                    case NSURLErrorNotConnectedToInternet:
                        // Handle no internet connection
                        downloadAudioCallback?(.failure(kNetwork))
                        triggerLocalNotification(title: failure, subtitle: (kNetwork))
                    case NSURLErrorTimedOut:
                        downloadAudioCallback?(.failure(kRequestMsg))
                        triggerLocalNotification(title: failure, subtitle: (kRequestMsg))
                    default:
                        break
                    }
                }
            }
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
                triggerLocalNotification(title: successNotificationTitle, subtitle: successNotifcationSubtitle)
                downloadAudioCallback?(.downloaded(destinationUrl))
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            downloadAudioCallback?(.failure(dirErrorMsg(error.localizedDescription)))
            triggerLocalNotification(title: failure, subtitle: dirErrorMsg(error.localizedDescription))
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
    func triggerLocalNotification(title: String, subtitle: String) {
        if isNotificationEnable() {
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = subtitle//notificationDescription(mediaName)
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    private func isNotificationEnable() -> Bool {
        return UserDefaults.standard.bool(forKey: localNotification)
    }
    
}
