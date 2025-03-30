import SwiftUI

enum CalendarMode: String, CaseIterable {
    case day = "День"
    case week = "Неделя"
    case month = "Месяц"
}

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var calendarMode: CalendarMode = .week
    
    
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
                DayView(selectedDate: $selectedDate)
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
