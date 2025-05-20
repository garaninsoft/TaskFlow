import SwiftUI
import SwiftData

enum CalendarMode: String, CaseIterable {
    case day = "День"
    case week = "Неделя"
    case month = "Месяц"
}

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var calendarMode: CalendarMode = .week
    
    @Query private var meetings: [Schedule]
    
    // Вычисляемое свойство для фильтрации по selectedDate
    private var filteredMeetings: [Schedule] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return meetings.filter { meeting in
            guard let start = meeting.start, let finish = meeting.finish else { return false }
            
            // Встреча попадает в день, если:
            // 1. Начинается в этот день ИЛИ
            // 2. Заканчивается в этот день ИЛИ
            // 3. Пересекает этот день (началась раньше и закончилась позже)
            return (start >= startOfDay && start < endOfDay) ||    // Начало в этот день
                   (finish >= startOfDay && finish < endOfDay) ||  // Конец в этот день
                   (start < startOfDay && finish >= endOfDay)      // Пересекает весь день
        }
    }
    
    private var weeklyMeetings: [Schedule] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
        let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
        
        return meetings.filter { meeting in
            guard let start = meeting.start, let finish = meeting.finish else { return false }
            let startsInWeek = start >= startOfWeek && start < endOfWeek
            let endsInWeek = finish >= startOfWeek && finish < endOfWeek
            let spansWeek = start < startOfWeek && finish >= endOfWeek
            return startsInWeek || endsInWeek || spansWeek
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Панель управления с переключением режимов
            ControlPanelView(selectedDate: $selectedDate, calendarMode: $calendarMode)
            
            // Основное содержимое календаря
            calendarContent
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    private var calendarContent: some View {
        Group {
            switch calendarMode {
            case .day:
                DayView(selectedDate: $selectedDate, meetings: filteredMeetings)
            case .week:
                WeekView(selectedDate: $selectedDate)
            case .month:
                MonthView(selectedDate: $selectedDate)
            }
        }
    }
}

// Предварительный просмотр
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .frame(width: 800, height: 600)
    }
}
