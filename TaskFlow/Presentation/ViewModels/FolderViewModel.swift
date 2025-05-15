//
//  FolderViewModel.swift
//  TaskFlow
//
//  Created by alexandergaranin on 14.05.2025.
//

import Foundation

final class FolderViewModel: ObservableObject {
//    private let rootPath = "~/Documents/"
    private let rootPath = "/Users/alexandergaranin/dst/Desktop2/repetitor2/"
    private let fileSystemService: FileSystemServiceProtocol

    // Публикуем состояние для UI
    @Published var errorMessage: String?
    @Published var isSuccess: Bool = false
    
    init(fileSystemService: FileSystemServiceProtocol = FileSystemService()) {
        self.fileSystemService = fileSystemService
    }
    
    func createAndOpenFolder(at orderName: String){
        let path = rootPath + orderName
        do {
            try fileSystemService.createFolderIfNeeded(at: path)
            try fileSystemService.openFolderInFinder(at: path)
            isSuccess = true
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            isSuccess = false
        }
        
//        let homeDir = NSHomeDirectory()
//        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let desktopDir = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
//
//        print("""
//          Sandbox Report:
//          - Home: \(homeDir)
//          - Documents: \(documentsDir.path)
//          - Desktop: \(desktopDir.path)
//          - Downloads: \(FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!.path)
//        """)
    }
}
