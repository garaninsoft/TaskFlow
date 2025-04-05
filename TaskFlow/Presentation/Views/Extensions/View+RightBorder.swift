//
//  View+RightBorder.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.04.2025.
//
import SwiftUI

extension View {
    func rightBorderStyle(
        width: CGFloat,
        alignment: Alignment = .trailing,
        padding: CGFloat = 0,
        borderHeight: CGFloat? = nil,
        borderСolor: Color = .gray
    ) -> some View {
        self
            .frame(width: width - padding, alignment: alignment)
            .padding(alignment == .leading ? .leading : .trailing, padding)
            .rightBorder(height: borderHeight, color: borderСolor)
    }
}

extension View {
    @ViewBuilder
    func rightBorder(height: CGFloat? = 20, color: Color) -> some View {
        if let height = height{
            self.overlay(
                Rectangle()
                    .frame(width: 1, height: height)
                    .foregroundColor(color.opacity(0.3)),
                alignment: .trailing
            )
        } else{
            self
        }
    }
}
