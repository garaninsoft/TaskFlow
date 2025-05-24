//
//  FolderViewModel.swift
//  TaskFlow
//
//  Created by alexandergaranin on 14.05.2025.
//

import Foundation

final class FolderViewModel: ObservableObject {
    private let fileSystemService = FileSystemService()
    
    // Публикуем состояние для UI
    @Published var errorMessage: String?
    @Published var isSuccess: Bool = false

    func createAndOpenOrderFolder(at orderName: String){
        let path = Constants.rootOrdersPath + orderName
        do {
            try fileSystemService.createFolderIfNeeded(at: path)
            try fileSystemService.openFolderInFinder(at: path)
            isSuccess = true
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            isSuccess = false
        }
    }
    
    func openFolder(at path: String){
        do {
            try fileSystemService.openFolderInFinder(at: path)
            isSuccess = true
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            isSuccess = false
        }
    }
}
