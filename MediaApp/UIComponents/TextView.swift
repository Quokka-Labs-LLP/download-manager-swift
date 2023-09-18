//
//  TextView.swift
//  MediaApp
//
//  Created by Abhishek Pandey on 04/09/23.
//

import SwiftUI

struct TextView: View {
    var text = ""
    var body: some View {
        Text(text)
            .padding(.vertical, kThirty)
            .font(.system(size: kTwentyFour))
            .fontWeight(.bold)
            .padding(.leading, kThirty)
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView()
    }
}
