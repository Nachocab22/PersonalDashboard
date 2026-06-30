//
//  DashboardView.swift
//  PersonalDashboard
//
//  Created by Nachete on 20/06/2026.
//

import SwiftUI

struct DashboardView: View {
    
    

    var body: some View {
        TitleSection()
        VStack() {
            VStack{
                HStack {
                    AgendaView()
                    TaskView()
                }
            }
                HabitView()
        }
    }
}

struct TitleSection: View {
    
    @State private var now = Date.now
    
    var body: some View {
        VStack(alignment: .leading){

            Text("Dashboard")
                .font(.custom("Default", size: 50))
                .bold()
            
            HStack(alignment: .top) {
                    
                Text(Date.now.formatted(date: .long, time: .omitted))
                    .font(.title)
                    
                Spacer()
                    
                TimelineView(.periodic(from: .now, by: 1)) { context in
                    Text(
                        context.date.formatted(
                            date: .omitted,
                            time: .shortened
                        )
                    )
                    .font(.largeTitle)
                    .bold()
                }
                        
            }
        }.padding()
    }
}

#Preview {
        DashboardView()
}
