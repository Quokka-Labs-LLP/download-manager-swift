//
//  File.swift
//  
//
//  Created by Abhishek Pandey on 15/09/23.
//

import Foundation


//MARK: - ServiceLocator Protocol
protocol ServiceLocator {
    
    /// Retrieves an instance of the PlayerManager.
    func getPlayerManager() -> PlayerManager
    
    /// Retrieves an instance of the DownloadTask.
    func getDownloadTask() -> DownloadTask
}

//MARK: - ServiceLocator Implementation
class Services: ServiceLocator {
    
    /// Retrieves an instance of the PlayerManager.
    func getPlayerManager() -> PlayerManager {
        return PlayerManager()
    }
    
    /// Retrieves an instance of the DownloadTask.
    func getDownloadTask() -> DownloadTask {
        return DownloadTask()
    }
  
}
