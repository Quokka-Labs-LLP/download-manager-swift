//
//  MediaAppApp.swift
//  MediaApp
//
//  Created by Abhishek Pandey on 01/09/23.
//

import SwiftUI

@main
struct MediaPlayerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TabBarView()
            }.navigationBarBackButtonHidden(true)
        }
    }
}
