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
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(title)
           hasher.combine(width)
       }
       
       static func == (lhs: Self, rhs: Self) -> Bool {
           lhs.title == rhs.title && lhs.width == rhs.width
       }
}
