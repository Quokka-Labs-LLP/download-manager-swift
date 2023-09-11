//
//  BackButtonView.swift
//  
//
//  Created by Abhishek Pandey on 30/08/23.
//

import SwiftUI

struct BackButtonView: View {
    
    //MARK: - Properties
    @Environment(\.dismiss) public var dismiss
    @ObservedObject var player: PlayerManager
    
    //MARK: - body
    var body: some View {
        HStack{
            Button {
                dismiss()
                player.deinitPlayer()
            } label: {
                Image(kBack)
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(width: kTwenty * screenWidthFactor, height: kTwenty * screenWidthFactor)
                    .padding(.leading, kTwenty)
            }
            Spacer()
        }
    }
}

