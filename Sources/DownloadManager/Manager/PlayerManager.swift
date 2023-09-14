//
//  PlayerManager.swift
//  
//
//  Created by Abhishek Pandey on 30/08/23.
//

import SwiftUI
import Combine
import AVKit


public class PlayerManager: ObservableObject {
    
    //MARK: - Properties
    @Published public var isPlay: Bool = false
    @Published public var totalDuration: Double = 0.0
    @Published public var currentDuration: Double = 0.0
    public var audioTimeInterval: Float64 = 30
    
    //MARK: - Intializer
    public init() {

        }
    //MARK: - Play Audio
    public func playAudio(with url: String) {
        deinitPlayer()
        if let urlPath = getMediaPath(of: url) {
            let asset = AVURLAsset(url: urlPath, options: nil)
            let playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer.init(playerItem: playerItem)
            totalDuration = CMTimeGetSeconds(asset.duration)
            let interval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
                self.currentDuration = CMTimeGetSeconds(time)
            }
            player?.play()
            isPlay = true
        }
    }
    
    //MARK: Pause Audio
    public func pauseAudio() {
        isPlay = false
        player?.pause()
    }
    
    // MARK: Resume Audio
    public func resumeAudio() {
        player?.play()
        isPlay = true
    }
    
    //MARK: Remove Player Current Item
    public func deinitPlayer() {
        player?.replaceCurrentItem(with: nil)
        player = nil
    }
    
    //MARK: - getMeidaPath
    public func getMediaPath(of url : String) -> URL?  {
        if let searchPathDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let documentDirectory = URL(fileURLWithPath:searchPathDirectory)
            do {
                // List the contents of the directory
                let urlName = url.components(separatedBy: "/").last ?? ""
                let contents = try? FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: [])
                if let fileURL = contents?.first(where: { $0.lastPathComponent.contains(urlName) }) {
                    return fileURL
                }
            }
        }
        return nil
    }
    
    //MARK:  Play Video
    public func playVideo(url: String) {
        if let urlPath = getMediaPath(of: url) {
            let videoAsset = AVURLAsset(url: urlPath, options: nil)
            let videoPlayerItem = AVPlayerItem(asset: videoAsset)
            let player = AVPlayer(playerItem: videoPlayerItem)
            let vc = AVPlayerViewController()
            vc.player = player
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let topViewController = windowScene.windows.first?.rootViewController {
                topViewController.present(vc, animated: true) {
                    vc.player?.play()
                }
            }
        }
    }
    
    //MARK: - Forward interval
    public func skipForward() {
        if player == nil { return }
        if let duration = player?.currentItem?.duration {
            if let currentTime = player?.currentTime(){
                let playerCurrentTime = CMTimeGetSeconds(currentTime)
                let newTime = playerCurrentTime + audioTimeInterval
                if newTime < CMTimeGetSeconds(duration) {
                    let selectedTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
                    player?.seek(to: selectedTime)
                    player?.pause()
                    player?.play()
                }
            }
        }
    }
    
    //MARK: - Backward interval
    public func skipBackward() {
        if player == nil { return }
        if let currentTime = player?.currentTime() {
            let playerCurrentTime = CMTimeGetSeconds(currentTime)
            let newTime = playerCurrentTime - audioTimeInterval
            if newTime >= 0 {
                let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
                player?.seek(to: selectedTime)
            }
            player?.pause()
            player?.play()
        }
    }
    
    //MARK: Change audio player seek with slider
    public func updateSeek(with value: Double) {
        let selectedTime: CMTime = CMTimeMake(value: Int64(value * 1000 as Float64), timescale: 1000)
        player?.seek(to: selectedTime)
    }
}
