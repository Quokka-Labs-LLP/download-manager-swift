//
//  File.swift
//  
//
//  Created by Abhishek Pandey on 12/09/23.
//

import Foundation

extension Double {
    
    //MARK: getTime
    func getSecondInTime() -> (Int, Int) {
        let minutes = Int(self) / 60
        let reminderSeconds = Int(self) % 60
        return(minutes, reminderSeconds)
    }
}
