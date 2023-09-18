//
//  HeaderView.swift
//  MediaApp
//
//  Created by Abhishek Pandey on 08/09/23.
//

import SwiftUI
import DownloadManager

struct HeaderView: View {
    
    //MARK: Properties
    @StateObject var downloadManager = DownloadManager(notificationMessage: NotificationMessage())
    @State var notifitcation = true
    var title = "Audio List"
    
    
    var body: some View {
        HStack {
            TextView(text: title)
            Spacer()
            Toggle("", isOn: $notifitcation).onChange(of: notifitcation, perform: { newValue in
                downloadManager.notificationConfiguration(isRequire: notifitcation)
            })
                .padding(.trailing, kThirty)
        }
        .onAppear {
            notifitcation = downloadManager.isNotificationEnable()
            
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
