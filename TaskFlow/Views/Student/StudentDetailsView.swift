//
//  StudentDetailView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 03.03.2025.
//

import SwiftUI

struct StudentDetailsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showSheetNewStudent = false
    @State private var selection: String?
    var student: Student
    
    var body: some View {
        VStack{
            Text(student.name)
            Text("Orders")
            let orders = student.orders?.sorted(using: KeyPathComparator(\Order.created)) ?? []
            
            List(selection: $selection){
                ForEach (orders){ order in
                    Text(order.details)
                        .contextMenu {
                            Button(
                                action: {
                                    
                                }
                            ){
                                Text("Update")
                            }
                            Button(
                                action: {
                                    withAnimation {
                                        d(order: order)
                                    }
                                }
                            ){
                                Text("Delete")
                            }
                        }
                    
                }
            }
            
            Button("Update"){
                showSheetNewStudent.toggle()
            }.sheet(isPresented: $showSheetNewStudent) {
                UpdateStudentView(student: student)
            }
            
            Button("Insert"){
                student.orders?.append(Order(details: "12345", created: Date()))
            }
        }
    }
    
    private func d(order:Order){
        if let index = student.orders?.firstIndex(where: {$0 == order}) {
            student.orders?.remove(at: index)
        }
    }
}

#Preview {
    StudentDetailsView(student: Student(name: "Vasia", contacts: "123", created: Date()))
}
