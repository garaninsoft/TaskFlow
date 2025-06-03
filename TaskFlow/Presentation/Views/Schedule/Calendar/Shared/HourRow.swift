//
//  HourRow.swift
//  TaskFlow
//
//  Created by alexandergaranin on 26.03.2025.
//

import SwiftUI

struct HourRow: View {
    let hour: Int
    let busyMinutes: [BusyMinute]
    private let totalMinutesInHour: Int = 60
    
    // Отсортированные и проверенные интервалы
//    var processedIntervals: [(start: Int, end: Int)] {
//        let intervals = splitIntoIntervals(busyMinutes)
//        let sorted = intervals.sorted { $0.start < $1.start }
//        //checkForOverlaps(sorted) // Проверка пересечений
//        return sorted
//    }
    
    var body: some View {
        HStack(spacing: 8) {
            // Разметка четвертей часа слева
            quarterMarks(hour: hour)
            
            // Основная визуализация
            VStack(spacing: 0) {
                if busyMinutes.isEmpty {
                    Rectangle()
                        .fill(Color.green.opacity(0.3))
                        .frame(height: CalendarConstants.heightHourRow)
                } else {
                    drawTimeBlocks()
                }
            }
            .frame(height: CalendarConstants.heightHourRow)
            .background(Color.gray.opacity(0.1))
        }
        .padding(.horizontal)
        
        
    }
    
    // MARK: - Методы визуализации
       
       /// Рисует разметку четвертей часа
    private func quarterMarks(hour: Int) -> some View {
           VStack(spacing: 0) {
               //String(format: "%02d:00", hour)
               ForEach(0..<4, id: \.self) { quarter in
                   let isHour = quarter == 0
                   Text(isHour ? String(format: "%02d:00", hour) : "\(quarter * 15) min")
                       .font(.system(size: isHour ? 14 : 9))
                       .frame(height: CalendarConstants.heightHourRow/4, alignment: isHour ? .topLeading : .top)
                       
               }
           }
           .frame(width: 50)
       }
       
       /// Рисует все временные блоки
       private func drawTimeBlocks() -> some View {
           Group {
               // Начальный свободный интервал
               if busyMinutes[0].startMinute > 0 {
                   freeTimeBlock(height: busyMinutes[0].startMinute)
               }
               
               // Основные интервалы
               ForEach(Array(busyMinutes.enumerated()), id: \.offset) { index, interval in
                   busyTimeBlock(interval: interval)
                   
                   // Свободный интервал до следующего занятого
                   if index < busyMinutes.count - 1 {
                       let nextStart = busyMinutes[index + 1].startMinute
                       if interval.endMinute < nextStart {
                           freeTimeBlock(height: nextStart - interval.endMinute)
                       }
                   }
               }
               
               // Конечный свободный интервал
               if let lastEnd = busyMinutes.last?.endMinute, lastEnd < totalMinutesInHour {
                   freeTimeBlock(height: totalMinutesInHour - lastEnd)
               }
           }
       }
       
       // MARK: - Вспомогательные методы
       
//       /// Разбивает массив на интервалы с проверкой
//       private func splitIntoIntervals(_ busyMinutes: [BusyMinute]) -> [(start: Int, end: Int)] {
//           var intervals = [(start: Int, end: Int)]()
//           for i in stride(from: 0, to: minutes.count, by: 2) {
//               if i + 1 < minutes.count {
//                   let (start, end) = (minutes[i], minutes[i+1])
//                   if start < end {
//                       intervals.append((start, end))
//                   } else {
//                       print("⚠️ Некорректный интервал: [\(start), \(end)] пропущен")
//                   }
//               }
//           }
//           return intervals
//       }
       
//       /// Проверяет пересечения интервалов
//       private func checkForOverlaps(_ intervals: [(start: Int, end: Int)]) {
//           for i in 1..<intervals.count {
//               if intervals[i].start < intervals[i-1].end {
//                   print("⛔️ Пересечение интервалов: [\(intervals[i-1].start)-\(intervals[i-1].end)] и [\(intervals[i].start)-\(intervals[i].end)]")
//               }
//           }
//       }
       
       /// Блок занятого времени
    private func busyTimeBlock(interval: BusyMinute) -> some View {
           Rectangle()
               .fill(Color.red.opacity(0.5))
               .frame(height: CGFloat(interval.endMinute - interval.startMinute) * (CalendarConstants.heightHourRow / CGFloat(totalMinutesInHour)))
               .overlay(
                Text("\(interval.meeting.order?.student?.name ?? "")")
                       .font(.system(size: 10))
                       .foregroundColor(.white)
               )
       }
       
       /// Блок свободного времени
       private func freeTimeBlock(height: Int) -> some View {
           Rectangle()
               .fill(Color.green.opacity(0.3))
               .frame(height: CGFloat(height) * (CalendarConstants.heightHourRow / CGFloat(totalMinutesInHour)))
       }
}

//#Preview {
//    HourRow(hour: 13)
//        .padding()
//}
