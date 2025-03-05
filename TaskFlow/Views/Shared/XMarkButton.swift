//
//  XMarkButton.swift
//  TaskFlow
//
//  Created by alexandergaranin on 03.03.2025.
//

import SwiftUI

struct XMarkButton: View {
    var body: some View {
        Image(systemName: "xmark") //changed to image, can change color here if needed
            .font(.headline)
    }
}

#Preview {
    XMarkButton()
}
