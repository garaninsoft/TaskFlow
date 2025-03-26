import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var calendarMode: CalendarMode = .month
    
    enum CalendarMode: String, CaseIterable {
        case day = "День"
        case week = "Неделя"
        case month = "Месяц"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Панель управления с переключением режимов
            controlPanel
            
            // Основное содержимое календаря
            calendarContent
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    private var controlPanel: some View {
        HStack {
            // Кнопки переключения между периодами
            periodNavigationButtons
            
            Spacer()
            
            // Сегментированный контрол для выбора режима
            Picker("Режим", selection: $calendarMode) {
                ForEach(CalendarMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 300)
        }
        .padding()
    }
    
    private var periodNavigationButtons: some View {
        HStack(spacing: 20) {
            Button {
                withAnimation {
                    switch calendarMode {
                    case .day:
                        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
                    case .week:
                        selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate)!
                    case .month:
                        selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate)!
                    }
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
            }
            
            Text(periodTitle)
                .font(.headline)
                .frame(minWidth: 200)
            
            Button {
                withAnimation {
                    switch calendarMode {
                    case .day:
                        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
                    case .week:
                        selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedDate)!
                    case .month:
                        selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate)!
                    }
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.headline)
            }
        }
    }
    
    private var periodTitle: String {
        let formatter = DateFormatter()
        switch calendarMode {
        case .day:
            formatter.dateFormat = "d MMMM yyyy"
            return formatter.string(from: selectedDate)
        case .week:
            let weekFormatter = DateIntervalFormatter()
            weekFormatter.dateTemplate = "d MMM"
            let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: selectedDate)!
            return weekFormatter.string(from: weekInterval.start, to: weekInterval.end)
        case .month:
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: selectedDate)
        }
    }
    
    private var calendarContent: some View {
        Group {
            switch calendarMode {
            case .day:
                DayView(selectedDate: $selectedDate)
            case .week:
                WeekView(selectedDate: $selectedDate)
            case .month:
                MonthView(selectedDate: $selectedDate)
            }
        }
    }
}

// Дневной вид
struct DayView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(0..<24) { hour in
                    HourRow(hour: hour, date: selectedDate)
                        .padding(.vertical, 4)
                }
            }
            .padding()
        }
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .padding()
    }
}

// Недельный вид
struct WeekView: View {
    @Binding var selectedDate: Date
    
    private var weekDates: [Date] {
        guard let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: selectedDate) else {
            return []
        }
        
        var dates: [Date] = []
        for i in 0..<7 {
            if let date = Calendar.current.date(byAdding: .day, value: i, to: weekInterval.start) {
                dates.append(date)
            }
        }
        return dates
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовки дней недели
            HStack(spacing: 0) {
                ForEach(weekDates, id: \.self) { date in
                    DayHeader(date: date, isSelected: isSameDay(date, selectedDate))
                        .onTapGesture {
                            withAnimation {
                                selectedDate = date
                            }
                        }
                }
            }
            
            // Сетка календаря
            ScrollView {
                HStack(spacing: 0) {
                    // Колонка с часами
                    VStack(spacing: 0) {
                        ForEach(0..<24) { hour in
                            Text(String(format: "%02d:00", hour))
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(height: 60)
                        }
                    }
                    .frame(width: 50)
                    
                    // Колонки дней
                    ForEach(weekDates, id: \.self) { date in
                        DayColumn(date: date, isSelected: isSameDay(date, selectedDate))
                    }
                }
            }
        }
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .padding()
    }
    
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}

// Месячный вид
struct MonthView: View {
    @Binding var selectedDate: Date
    
    private var weeks: [[Date]] {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate),
              let firstWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start) else {
            return []
        }
        
        var weeks: [[Date]] = []
        var currentWeekStart = firstWeek.start
        
        while currentWeekStart < monthInterval.end {
            var week: [Date] = []
            for dayOffset in 0..<7 {
                if let date = calendar.date(byAdding: .day, value: dayOffset, to: currentWeekStart) {
                    week.append(date)
                }
            }
            weeks.append(week)
            currentWeekStart = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart)!
        }
        
        return weeks
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовки дней недели
            HStack(spacing: 0) {
                ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 8)
            
            // Сетка календаря
            VStack(spacing: 8) {
                ForEach(weeks, id: \.self) { week in
                    HStack(spacing: 0) {
                        ForEach(week, id: \.self) { date in
                            DayCell(date: date,
                                   isSelected: isSameDay(date, selectedDate),
                                   isCurrentMonth: isCurrentMonth(date))
                                .onTapGesture {
                                    withAnimation {
                                        selectedDate = date
                                    }
                                }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .padding()
    }
    
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    private func isCurrentMonth(_ date: Date) -> Bool {
        Calendar.current.isDate(date, equalTo: selectedDate, toGranularity: .month)
    }
}

// Общие компоненты
struct HourRow: View {
    let hour: Int
    let date: Date
    
    var body: some View {
        HStack(alignment: .top) {
            Text(String(format: "%02d:00", hour))
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 50, alignment: .leading)
            
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
                .padding(.top, 8)
        }
    }
}

struct DayHeader: View {
    let date: Date
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(date.formatted(.dateTime.weekday(.abbreviated)))
                .font(.caption)
                .foregroundColor(isSelected ? .blue : .secondary)
            
            Text(date.formatted(.dateTime.day()))
                .font(.headline)
                .foregroundColor(isSelected ? .blue : .primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        .cornerRadius(8)
    }
}

struct DayColumn: View {
    let date: Date
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<24) { _ in
                Rectangle()
                    .fill(isSelected ? Color.blue.opacity(0.05) : Color.gray.opacity(0.05))
                    .frame(height: 60)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.2)),
                        alignment: .bottom
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .border(Color.gray.opacity(0.2), width: 0.5)
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    
    var body: some View {
        VStack {
            Text(date.formatted(.dateTime.day()))
                .font(.headline)
                .foregroundColor(isCurrentMonth ? (isSelected ? .white : .primary) : .secondary)
                .frame(width: 30, height: 30)
                .background(isSelected ? Color.blue : Color.clear)
                .clipShape(Circle())
            
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(isCurrentMonth ? Color.clear : Color.gray.opacity(0.05))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.1)),
            alignment: .bottom
        )
    }
}

// Предварительный просмотр
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .frame(width: 800, height: 600)
    }
}
