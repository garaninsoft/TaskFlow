//
//  StudentDetailView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 03.03.2025.
//

import SwiftUI
import SwiftData

struct StudentDetailsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var showSheetNewStudent = false
    var student: Student
    
    //private var orders: [Order]
    
//    static let st = Student(name: "", contacts: "", created: Date())
//    
//    @Query(
//        filter: #Predicate<Order> { order in
//            order.student == st
//        }
//    ) private var orders: [Order]
        
    var orders = [
        Order(title: "1",details: "details 1", created: Date()),
        Order(title: "2",details: "details 2", created: Date()),
        Order(title: "3",details: "details 3", created: Date()),
    ]
    
    @State var selection: Order? = nil
    @State var cv:NavigationSplitViewVisibility = .all
    
    var body: some View {
//           
//        let orders = Self.orders.sorted(using: KeyPathComparator(\Order.created)) ?? []
        
        NavigationSplitView(columnVisibility: $cv) {
            List {
                ForEach(orders) { order in
                    Button(order.details){
                        selection = order
                    }
                    
                    //                    {
                    //      "                  //let _ = Self.logger.trace("hello \(student.name)")
                    //                        Text(order.details)
                    //                    }
                }
            }
        }detail: {
            Text(selection?.details ?? "aaa")
        }
        
        
        
//        NavigationSplitView {
//            List{
//                ForEach (orders){ order in
//                    NavigationLink{
//                        //let _ = Self.logger.trace("hello \(order.details)")
//                        //OrderDetailsView(order: order)
//                        Text(order.details)
//                    }label: {
//                        Text(order.details)
//                            .contextMenu {
//                                Button(
//                                    action: {
//                                        
//                                    }
//                                ){
//                                    Text("Update")
//                                }
//                                Button(
//                                    action: {
//                                        withAnimation {
//                                            d(order: order)
//                                        }
//                                    }
//                                ){
//                                    Text("Delete")
//                                }
//                            }
//                    }
//                }
//            }
//        }detail: {
//            Text("Select an Order")
//        }
            
//            Button("Update"){
//                showSheetNewStudent.toggle()
//            }.sheet(isPresented: $showSheetNewStudent) {
//                UpdateStudentView(student: student)
//            }
//            
//            Button("Insert"){
//                student.orders?.append(Order(details: String(Int.random(in: 1000..<2000)), created: Date()))
//            }
        
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
