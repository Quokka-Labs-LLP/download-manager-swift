//
//  Enum.swift
//  
//
//  Created by Abhishek Pandey on 29/08/23.
//

import Foundation


public enum TaskResult {
    case downloaded(URL)
    case progress(Float)
    case failure(String)
    case cancel
    case deleted(URL)

}
