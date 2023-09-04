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
                        let fileName = mediaUrl.components(separatedBy: "/")
                        Text(fileName.last ?? "").padding(.vertical, 5)
                        Text("\(player.currentDuration) / \(player.totalDuration)")
                    }
                    Spacer()
                }.padding(.vertical, kTwenty).padding(.horizontal,kTwenty)
                Button {
                    if player.isPlay {
                        player.pauseMedia()
                    } else {
                        player.resumeMedia()
                    }
                } label: {
                    Image(player.isPlay ? kPause: kPlay)
                        .resizable().frame(width: kFifty, height: kFifty)
                    
                }.padding(.top, kForty)
            }
        }.navigationBarBackButtonHidden(true)
            .onAppear {
                player.playMedia(with: mediaUrl)
            }
        
    }
}


