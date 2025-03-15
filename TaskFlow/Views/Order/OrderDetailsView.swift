//
//  OrderDetailsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 07.03.2025.
//

import SwiftUI

struct OrderDetailsView: View {
    var order: Order
    
    var body: some View {
        Text(order.details)
    }
}

