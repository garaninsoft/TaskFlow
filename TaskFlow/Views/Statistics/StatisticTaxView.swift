//
//  StatisticsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 28.03.2025.
//

import SwiftUI

struct StatisticTaxItem: Identifiable {
    let id = UUID()
    let category: String
    let declared: Double
    let undeclared: Double
}

struct StatisticTaxView: View {
    
    var order: Order
    private var statisticTaxItems: [StatisticTaxItem]
    @Binding var isPresented: Bool
    
    init(order: Order, isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        self.order = order
        self.statisticTaxItems = StatisticTaxView.getStatisticTax(order: order)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Заголовок
            Text("Декларация")
                .font(.title3.bold())
                .padding(.top, 12)
            
            // Таблица
            VStack(spacing: 0) {
                // Заголовки колонок
                HStack {
                    Text("Категория")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Учтено")
                        .frame(width: 150, alignment: .trailing)
                    Text("Неучтено")
                        .frame(width: 150, alignment: .trailing)
                }
                .font(.subheadline.bold())
                .foregroundColor(.secondary)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color(.controlBackgroundColor))
                .cornerRadius(4)
                
                // Строки данных
                ScrollView {
                    LazyVStack(spacing: 1) {
                        ForEach(statisticTaxItems) { record in
                            HStack {
                                Text(record.category)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                CurrencyView(amount: record.declared)
                                    .frame(width: 150, alignment: .trailing)
                                
                                CurrencyView(amount: record.undeclared)
                                    .frame(width: 150, alignment: .trailing)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(.windowBackgroundColor))
                        }
                    }
                    .padding(1)
                    .background(Color(.separatorColor))
                }
                .frame(minHeight: 200, maxHeight: 400)
                .cornerRadius(6)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Кнопка закрытия (в стиле macOS)
            HStack {
                Spacer()
                Button(action: { isPresented = false }) {
                    Text("Закрыть")
                        .frame(minWidth: 80)
                }
                .controlSize(.large)
                .keyboardShortcut(.defaultAction)
            }
            .padding()
        }
        .frame(minWidth: 500, idealWidth: 550, maxWidth: .infinity,
               minHeight: 400, idealHeight: 450, maxHeight: .infinity)
        .background(Color(.windowBackgroundColor))
    }
    
    private static func getStatisticTax(order: Order) -> [StatisticTaxItem]{
        order.payments?.reduce(into: [String: (declared: Double, undeclared: Double)]()) { result, payment in
                let key = payment.category?.name ?? "Без категории"
                if payment.declared == true {
                    result[key, default: (0, 0)].declared += payment.amount
                } else if payment.declared == false {
                    result[key, default: (0, 0)].undeclared += payment.amount
                }
            }.map { category, sums in
                StatisticTaxItem(category: category, declared: sums.declared, undeclared: sums.undeclared)
            } ?? []
    }
    
}
    
// Вью для отображения суммы с цветом в зависимости от значения
struct CurrencyView: View {
    let amount: Double
    
    var body: some View {
        Text(formattedAmount)
            .foregroundColor(textColor)
    }
    
    private var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₽"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    private var textColor: Color {
        amount < 0 ? .red : (amount > 0 ? .green : .primary)
    }
}
    


#Preview {
    @Previewable @State var isPresent: Bool = false
    let items = [
        StatisticTaxItem(category: "Расходы по Категории1", declared: -2000, undeclared: -3000),
        StatisticTaxItem(category: "Расходы по Категории2", declared: -1500, undeclared: -0),
        StatisticTaxItem(category: "Расходы по Категории3", declared: -0, undeclared: -3000),
        StatisticTaxItem(category: "Приходы за занятия", declared: 12000, undeclared: 3000)
    ]
    
    let pc1 = PaymentCategory(name: "Cat 1")
    let pc2 = PaymentCategory(name: "Cat 2")
    let pc3 = PaymentCategory(name: "Cat 3")
    
    let order = Order(
        title: "",
        details: "",
        created: Date(),
        payments: [
            Payment(category: pc1, amount: -1000, declared: true, details: "", created: Date()),
            Payment(category: pc1, amount: -1000, declared: true, details: "", created: Date()),
            Payment(category: pc2, amount: 1000, declared: false, details: "", created: Date()),
            Payment(category: pc2, amount: 1000, declared: true, details: "", created: Date()),
            Payment(category: pc1, amount: -1000, declared: false, details: "", created: Date()),
            Payment(category: pc1, amount: -1000, declared: true, details: "", created: Date()),
            Payment(category: nil, amount: 1000, declared: true, details: "", created: Date()),
        ]
    )
    
    StatisticTaxView(order: order, isPresented: $isPresent)
}
