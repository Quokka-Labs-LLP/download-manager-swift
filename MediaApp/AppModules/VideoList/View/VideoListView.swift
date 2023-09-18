//
//  VideoListView.swift
//  MediaApp
//
//  Created by Abhishek Pandey on 01/09/23.
//

import SwiftUI
import DownloadManager

struct VideoListView: View {
    
    //MARK: - body
    var body: some View {
        VStack {
            HeaderView(title: kVideo)
            ScrollView {
                VStack(spacing: kTwenty) {
                    ForEach(0..<videoList.count, id: \.self) { i in
                        if let fileName = videoList[i].components(separatedBy: "/").last {
                            ContentDetailView(mediaName: fileName, mediaURL: videoList[i], mediaType: .video)
                        }}
                }.padding(.top, kTwenty)
            }
        }
    }
}

struct VideoListView_Previews: PreviewProvider {
    static var previews: some View {
        VideoListView()
    }
}
