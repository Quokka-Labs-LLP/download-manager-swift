//
//  DocListView.swift
//  MediaApp
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI

struct DocListView: View {
    
    //MARK: - body
    var body: some View {
        VStack {
            HeaderView(title: kDoc)
            ScrollView {
                VStack(spacing: kTwenty) {
                    ForEach(0..<docList.count, id: \.self) { i in
                        if let fileName = docList[i].components(separatedBy: "/").last {
                            ContentDetailView(mediaName: fileName, mediaURL: docList[i], mediaType: .doc)
                        }}
                }.padding(.top, kTwenty)
            }
        }
    }
}

struct DocListView_Previews: PreviewProvider {
    static var previews: some View {
        DocListView()
    }
}
