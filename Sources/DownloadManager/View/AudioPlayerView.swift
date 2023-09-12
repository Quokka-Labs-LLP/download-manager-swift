//
//  AudioPlayerView.swift
//  
//
//  Created by Abhishek Pandey on 30/08/23.
//

import SwiftUI

public struct AudioPlayerView: View {
    
    //MARK: - Properties
    @StateObject var player = PlayerManager()
    public var mediaUrl = ""
    
    //MARK: - body
    public var body: some View {
        GeometryReader {_ in
            VStack {
                BackButtonView(player: player)
                Image(kAudioplayerImage)
                    .resizable()
                    .frame(height: kFourHundred * screenWidthFactor).cornerRadius(10)
                    .padding(.horizontal, kTwenty).padding(.top, kTwenty)
                HStack{
                    VStack(alignment: .leading) {
                        if let fileName = mediaUrl.components(separatedBy: "/").last {
                            Text(fileName).padding(.vertical, 5)
                            Text("\(player.currentDuration) / \(player.totalDuration)")
                        }
                    }
                    Spacer()
                }.padding(.vertical, kTwenty).padding(.horizontal,kTwenty)
                HStack(spacing: kThirty) {
                    buttonConfig(with: .backward)
                    buttonPlay()
                    buttonConfig(with: .forward)
                }.padding(.top, kForty)
            }
        }.navigationBarBackButtonHidden(true)
            .onAppear {
                player.playAudio(with: mediaUrl)
            }
        
    }
    
    //MARK: ButtonConfig - For forward and backward time interval
    private func buttonConfig(with intervalType: AudioIntervalType) -> some View {
        Group {
            Button {
                if intervalType == .forward {
                    player.skipForward()
                } else {
                    player.skipBackward()
                }
            } label: {
                Image(intervalType.rawValue).resizable().frame(width: kThirty, height: kThirty)
            }
        }
    }
    
    //MARK: Audio play / pause action helper
    private func buttonPlay() -> some View {
        Group {
            Button {
                if player.isPlay {
                    player.pauseAudio()
                } else {
                    player.resumeAudio()
                }
            } label: {
                Image(player.isPlay ? kPause: kPlay)
                    .resizable().frame(width: kFifty, height: kFifty)
                
            }
        }
    }
    
    
}


