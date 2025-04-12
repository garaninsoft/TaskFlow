//
//  TitleColumnItem.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.04.2025.
//
import SwiftUI

struct TitleColumnItem: Hashable{
    let title: String
    let alignment: Alignment
    let font: Font
    let width: CGFloat
    let borderHeight: CGFloat
    
    init(title: String, alignment: Alignment, font: Font, width: CGFloat, borderHeight: CGFloat = 0) {
        self.title = title
        self.alignment = alignment
        self.font = font
        self.width = width
        self.borderHeight = borderHeight
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(title)
           hasher.combine(width)
       }
       
       static func == (lhs: Self, rhs: Self) -> Bool {
           lhs.title == rhs.title && lhs.width == rhs.width
       }
}
