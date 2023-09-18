//
//  TabBarView.swift
//  MediaApp
//
//  Created by Abhishek Pandey on 01/09/23.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            AudioListView()
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Audio")
                }
            
            VideoListView()
                .tabItem {
                    Image(systemName: "film")
                    Text("Video")
                }
            
            DocListView()
                .tabItem {
                    Image(systemName: "doc.fill")
                    Text("Doc")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
