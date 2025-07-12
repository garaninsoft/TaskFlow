//
//  PathPickerView.swift
//  TaskFlow
//
//  Created by Александр Гаранин on 12.07.2025.
//

import SwiftUI

struct PathPickerView: View {
    @Binding var path: String
    @Binding var folderURL: URL?
    let title: String
    
    var body: some View {
        HStack {
            TextField(title, text: $path)
                .textFieldStyle(.roundedBorder)
            Button("Выбор папки") {
                FolderPicker(folderURL: $folderURL).pickFolder()
                if let folderURL {
                    path = folderURL.relativePath + "/"
                }
            }
        }
    }
}

private struct FolderPicker: NSViewRepresentable {
    @Binding var folderURL: URL?

    func makeNSView(context: Context) -> some NSView {
        let view = NSView()
        return view
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {}

    func pickFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK {
            folderURL = panel.urls.first
        }
    }
}

