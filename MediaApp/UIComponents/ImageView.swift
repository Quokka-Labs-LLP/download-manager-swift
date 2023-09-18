//
//  ImageView.swift
//  Demo
//
//  Created by Abhishek Pandey on 01/09/23.
//

import SwiftUI


struct ImageView: View {
    var imageName = ""
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)
        
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
    }
}
