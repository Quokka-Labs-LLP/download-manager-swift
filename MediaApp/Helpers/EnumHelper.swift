//
//  Helper.swift
//  Demo
//
//  Created by Abhishek Pandey on 30/08/23.
//

import Foundation

enum MediaType {
    case audio
    case video
    case doc
}

enum MediaStatus {
    case downloaded
    case progress(Float)
    case initial
}
