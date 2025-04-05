//
//  UpdateWorkView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.04.2025.
//

import SwiftUI

struct UpdateWorkView: View {
    let work: Work
    @Binding var isPresented: Bool
    let actionUpdateWork: (Work)-> Void
    
    var body: some View {
        WorkForm(
            work: work,
            titleForm: "Update Work",
            captionButtonSuccess: "Update",
            isPresented: $isPresented,
            action: actionUpdateWork
        )
    }
}
