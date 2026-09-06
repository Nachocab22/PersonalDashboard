//
//  AgendaView.swift
//  PersonalDashboard
//
//  Created by Nachete on 25/06/2026.
//

import SwiftUI

struct AgendaView: View {
    
    struct Event : Identifiable {
        let id: UUID = UUID()
        let name: String?
        let location: String?
        let startDate: Date
        let endDate: Date
        let calendarColor: Color
        let isAllDay: Bool
        
        init(id: UUID = UUID(), name: String? = "Nuevo evento", location: String? = nil, startDate: Date, endDate: Date, calendarColor: Color, isAllDay: Bool = false) {
            self.name = name
            self.location = location
            self.startDate = startDate
            self.endDate = endDate
            self.calendarColor = calendarColor
            self.isAllDay = isAllDay
        }
    }
    
    var events: [Event] = [
        Event(name: "Peluquería", location: "Peluquería Rocío Nandez", startDate: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 27, hour: 10, minute: 30))!, endDate: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 27, hour: 11, minute: 0))!, calendarColor: .yellow),
        Event(name: "Review Skills", location: "Edificio Realia, 9", startDate: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 27, hour: 12, minute: 30))!, endDate: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 27, hour: 13, minute: 30))!, calendarColor: .purple),
        Event(name: "Daily", startDate: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 27, hour: 9, minute: 30))!, endDate: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 27, hour: 9, minute: 45))!, calendarColor: .purple),
        Event(name: "Hacer declaración de la Rentas", startDate: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 27))!, endDate: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 27))!, calendarColor: .purple, isAllDay: true)
    ]
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Agenda")
                .font(Font.system(size: 30, weight: .semibold))
                .padding()
            List {
                Section {
                    ForEach(events.filter { $0.isAllDay }) { event in
                        EventRow(event: event)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    }
                }
                Section {
                    Rectangle()
                        .opacity(0.2)
                        .frame(height: 2)
                        .cornerRadius(10)
                    ForEach(events
                            .filter { !$0.isAllDay }
                            .sorted { $0.startDate < $1.startDate }
                    ) { event in
                        EventRow(event: event)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}
    
#Preview {
    AgendaView()
}

struct EventRow: View {
    
    var event: AgendaView.Event
    
    var body: some View {
        if(event.isAllDay){
            HStack(alignment: .top){
                VStack(alignment: .leading, spacing: 6){
                    Text(event.name ?? "Nuevo evento")
                        .font(Font.system(size: 18, weight: .bold))
                    event.location != nil ?
                    HStack{
                        Image(systemName: "location.circle")
                        event.location != nil ? Text(event.location ?? "Sin información") : Text("Sin ubicación").foregroundStyle(Color.gray)
                    } : nil
                }.frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                if(event.location == nil){
                    ZStack {
                        Circle()
                            .fill(event.calendarColor)
                            .frame(width: 15)
                    }.frame(maxHeight: .infinity, alignment: .center)
                    
                } else {
                    Rectangle()
                        .fill(event.calendarColor)
                        .frame(width: 8)
                        .cornerRadius(10)
                }
                
            }
            .padding()
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2)
            )
        } else {
            HStack(alignment: .top){
                VStack(alignment: .leading, spacing: 6){
                    Text(event.name ?? "Nuevo evento")
                        .font(Font.system(size: 18, weight: .bold))
                    HStack{
                        Image(systemName: "location.circle")
                        event.location != nil ? Text(event.location ?? "Sin información") : Text("Sin ubicación").foregroundStyle(Color.gray)
                    }
                    HStack{
                        Image(systemName: "clock")
                        Text("\(event.startDate.formatted(date: .omitted, time: .shortened)) - \(event.endDate.formatted(date: .omitted, time: .shortened))")
                    }
                }.frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                Rectangle()
                    .fill(event.calendarColor)
                    .frame(width: 8)
                    .cornerRadius(10)
                
            }
            .padding()
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2)
            )
        }
    }
}
