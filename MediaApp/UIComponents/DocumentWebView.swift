//
//  DocumentWebView.swift
//  MediaApp
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI
import WebKit

struct DocumentWebView: View {
    // Provide the URL of the document file in the document directory
    let documentURL: URL
    
    var body: some View {
        WebView(url: documentURL)
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
