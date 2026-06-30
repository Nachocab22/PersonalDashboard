//
//  DashboardView.swift
//  PersonalDashboard
//
//  Created by Nachete on 20/06/2026.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var orientacion: UIDeviceOrientation = UIDevice.current.orientation
    
    var body: some View {
        TitleSection()
        
        if(orientacion.isLandscape){
            GeometryReader { geo in
            
                let agendaWidth = geo.size.width * 0.35
                let taskWidth = geo.size.width * 0.35
                let habitWidth = geo.size.width * 0.3
                
                HStack(alignment: .top) {
                    AgendaView().frame(width: agendaWidth)
                    TaskView().frame(width: taskWidth)
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
                    TaskView()
                    
                }
                HabitView()
            }.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                self.orientacion = UIDevice.current.orientation
            }
        }
    }
}

struct TitleSection: View {
    
    @State private var now = Date.now
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading){

                Text("Dashboard")
                    .font(.custom("Default", size: 50))
                    .bold()
                
                Text(Date.now.formatted(date: .long, time: .omitted))
                    .font(.title)
                
                
                        
                            
            }
            Spacer()
            TimelineView(.periodic(from: .now, by: 1)) { context in
                Text(
                    context.date.formatted(
                        date: .omitted,
                        time: .shortened
                    )
                )
                .font(Font.system(size: 60))
                .bold()
            }
                .padding(.top, 15)
                .padding(.trailing, 30)
        }.padding()
    }
}

#Preview {
        DashboardView()
}
