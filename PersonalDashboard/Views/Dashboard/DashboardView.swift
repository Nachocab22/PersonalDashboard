//
//  DashboardView.swift
//  PersonalDashboard
//
//  Created by Nachete on 20/06/2026.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var orientacion: UIDeviceOrientation = UIDevice.current.orientation
    @State var selectedDay = Date.now
    @State var isCalendarShown: Bool = false
    
    var body: some View {
        TitleSection(selectedDay: $selectedDay, isCalendarShown: $isCalendarShown)
        
        if(orientacion.isLandscape){
            GeometryReader { geo in
            
                let agendaWidth = geo.size.width * 0.35
                let taskWidth = geo.size.width * 0.35
                let habitWidth = geo.size.width * 0.3
                
                HStack(alignment: .top) {
                    AgendaView().frame(width: agendaWidth)
                    TaskView(day: selectedDay).frame(width: taskWidth)
                    HabitView().frame(width: habitWidth)
                }.frame(width: geo.size.width, height: geo.size.height)
                    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                        self.orientacion = UIDevice.current.orientation
                    }
                    .padding(.horizontal, 24)
                
            }
        } else {
            VStack() {
                HStack {
                    AgendaView()
                    TaskView(day: selectedDay)
                    
                }
                HabitView()
            }.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                self.orientacion = UIDevice.current.orientation
            }
        }
    }
}

struct TitleSection: View {
        
    @Binding var selectedDay: Date
    @Binding var isCalendarShown: Bool
    
    @AppStorage("usesTwelveHourClock")
    private var usesTwelveHourClock = false
    
    private static let twelveHourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.dateFormat = "h:mm a"
        return formatter
    }()

    private static let twentyFourHourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.dateFormat = "H:mm"
        return formatter
    }()
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading){

                Text("Dashboard")
                    .font(.custom("Default", size: 50))
                    .bold()
                HStack(alignment: .center){
                    Button(action: {isCalendarShown = true}, label: {
                        Text(selectedDay.formatted(date: .long, time: .omitted))
                            .font(.title)
                        Image(systemName: "chevron.down")
                    })
                    .buttonStyle(.borderless).foregroundStyle(.primary)
                    .popover(isPresented: $isCalendarShown) {
                        VStack {
                            DatePicker(
                                "Nueva fecha",
                                selection: $selectedDay,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.graphical)
                            HStack (alignment: .center){
                                Spacer()

                                Button("Hoy") {
                                    selectedDay = .now
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }.padding()
                        .frame(width: 330)
                        .presentationCompactAdaptation(.popover)
                    }
                }
            }
            Spacer()
            Button{
                withAnimation(.snappy(duration: 0.3)) {
                    usesTwelveHourClock.toggle()
                }
            } label: {
                TimelineView(.everyMinute) { context in
                    Text(formattedTime(context.date))
                    .contentTransition(.numericText())
                    .font(Font.system(size: 60))
                    .bold()
                    .monospacedDigit()
                }
                    .padding(.top, 15)
                    .padding(.trailing, 30)
            }.buttonStyle(.borderless)
                .foregroundStyle(.primary)
                .accessibilityLabel("Cambiar formato de hora")
            
        }.padding()
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = usesTwelveHourClock
            ? Self.twelveHourFormatter
            : Self.twentyFourHourFormatter

        return formatter.string(from: date)
    }
}

#Preview("Idea inicial") {
    DashboardView()
}
