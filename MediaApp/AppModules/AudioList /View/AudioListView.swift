//
//  AudioListView.swift
//  MediaApp
//
//  Created by Abhishek Pandey on 01/09/23.
//

import SwiftUI
import DownloadManager

struct AudioListView: View {
    //MARK: - Properties
    @State var isNotification = true
    
    //MARK: - body
    var body: some View {
        VStack {
            HeaderView(title: kAuido)
            ScrollView {
                VStack(spacing: kTwenty) {
                    ForEach(0..<audioUrlList.count, id: \.self) { i in
                        let fileName = audioUrlList[i].components(separatedBy: "/")
                        if let mediaName = fileName.last {
                            ContentDetailView(mediaName: mediaName, mediaURL: audioUrlList[i], mediaType: .audio)
                        }}
                }.padding(.top, kTwenty)
            }
        }
    }
    
}

struct AudioListView_Previews: PreviewProvider {
    static var previews: some View {
        AudioListView()
    }
}
