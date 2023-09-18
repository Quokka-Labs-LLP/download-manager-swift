//
//  AudioDetailView.swift
//  MediaApp
//
//  Created by Abhishek Pandey on 01/09/23.
//

import SwiftUI
import DownloadManager

struct ContentDetailView: View {
    
    //MARK: - properties
    @StateObject private var downloadManager = DownloadManager(notificationMessage: NotificationMessage())
    @ObservedObject private var networkViewModel = NetworkViewModel(networkMonitor: try! Reachability())
    var mediaName = ""
    var mediaURL = ""
    var mediaType: MediaType = .audio
    
    //MARK: - body
    var body: some View {
        if networkViewModel.isRefresh {
            HStack {
                Text(mediaName)
                Group {
                    if downloadManager.isMediaExistInDir(with: mediaURL) {
                        callPlayerView(with: mediaType)
                    } else {
                        // MARK: call back of media file
                        
                        downloadMediaConfiguration(taskType: downloadManager.taskResult)
                    }
                }
            }
            .padding(.horizontal, kThirty).padding(.vertical,15)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 3)
            .padding(.horizontal)
        }
        
    }
    
    //MARK: callPlayerView
    @ViewBuilder
    func callPlayerView(with mediaType: MediaType) -> some View {
        Spacer()
        if mediaType == .audio {
            NavigationLink {
                AudioView(mediaUrl: mediaURL)
                //downloadManager.openAudioPlayer(with: mediaURL)
            } label: {
                ImageView(imageName: kPlayButton)
            }
        } else if mediaType == .doc {
            NavigationLink {
               let getURL = downloadManager.getExistMediaPath(with: mediaURL)
                if let url = getURL {
                    DocumentWebView(documentURL: url)
                        .navigationBarTitle("Document Viewer", displayMode: .inline)
                }
            } label: {
                ImageView(imageName: kPlayButton)
            }
            
        }
        
        else {
            Button {
                //downloadManager.openVideoPlayer(with: mediaURL)
            } label: {
                ImageView(imageName: kPlayButton)
            }
            
        }
    }
    
    //MARK: configDownloadButton
    @ViewBuilder
    func configDownloadButton() -> some View {
            Spacer()
            Button {
                if !mediaURL.isEmpty {
                    downloadManager.downloadMedia(with: mediaURL)
                }
            } label: {
                ImageView(imageName: kDownload)
            }
    }
    
    //MARK: Progress Config
    // set audio play current time
    @ViewBuilder
    func progressConfiguration(with value: Float) -> some View {
            let downloadValue = String(format: "%.2f", (Float(value) * 100))
            Text("\(downloadValue)%")
            Button {
                if !mediaURL.isEmpty {
                    downloadManager.cancelDownload(with: mediaURL)
                }
            } label: {
                ImageView(imageName: kCancel)
            }
    }
    
    @ViewBuilder
    private func downloadMediaConfiguration(taskType: TaskResult) -> some View {
        switch taskType {
        case .progress(let progress):
            Spacer()
            if progress > 0.0, progress < 1.0 {
                progressConfiguration(with: progress)
            } else {
                configDownloadButton()
            }
        case .downloaded(_):
            Spacer()
            callPlayerView(with: mediaType)
        case .failure(_):
            // show message when we get error during downloading
            configDownloadButton()
        case .cancel:
            // show message when we cancel the media during downloading
            configDownloadButton()
        case .deleted(_):
            // show message when we delete the media after download
            configDownloadButton()
        }
        
    }
}

struct AudioDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
