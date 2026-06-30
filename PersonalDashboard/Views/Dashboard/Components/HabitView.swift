//
//  HabitView.swift
//  PersonalDashboard
//
//  Created by Nachete on 27/06/2026.
//

import SwiftUI

struct HabitView: View {
    
    struct Habit: Identifiable {
        let id: UUID = UUID()
        let title: String
        let icon: String
        let repetitions: String
        var isCompleted: Bool = false
        var isActive: Bool = true
    }
    
    @State private var isModalShown: Bool = false
    @State private var habits: [Habit] = [
        Habit(title: "Ir al gym", icon: "figure.strengthtraining.traditional", repetitions: "m,s,d"),
        Habit(title: "Salir a correr", icon: "figure.run", repetitions: "l,s,d"),
        Habit(title: "Leer", icon: "book", repetitions: "l,m,x,j,v,s,d"),
        Habit(title: "Dibujar", icon: "paintbrush.pointed", repetitions: "l,m,x,d")
    ]
    
    let iconos: [String] = [
        "figure.strengthtraining.traditional",
        "figure.run",
        "book",
        "paintbrush.pointed",
        "figure.jumprope",
        "figure.run.treadmill",
        "figure.walk",
        "sunrise",
        "figure.pool.swim",
        "figure.fencing",
    ]
    
    let weekIcons: [String] = [
        "l.circle",
        "m.circle",
        "x.circle",
        "j.circle",
        "v.circle",
        "s.circle",
        "d.circle",
    ]
        
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    //Campos Form
    @State private var newHabitTitle: String = ""
    @State private var newHabitIcon: String = ""
    @State private var habitRepetitions: [String] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("Hábitos")
                .font(Font.system(size: 30, weight: .semibold))
                .padding()
            ScrollView(.horizontal, showsIndicators: false){
                HStack(alignment: .center, spacing: 10){
                    ForEach(habits.indices.filter { habits[$0].isActive }, id: \.self) { index in
                        let habit = habits[index]
                        HStack(spacing: 8) {
                            Image(systemName: habit.icon).font(.largeTitle)
                            Button(action: {
                                habits[index].isCompleted.toggle()
                            }) {
                                Image(systemName: habit.isCompleted ? "checkmark.square.fill" : "square")
                                    .foregroundStyle(habit.isCompleted ? .blue : .black)
                                    .font(.largeTitle)
                            }
                        }
                        .padding()
                        .background(.gray.opacity(0.2))
                        .clipShape(Capsule())
                    }
                    Button(action: {isModalShown = true}){
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .foregroundStyle(.black)
                            .padding()
                            .background(.gray.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }.frame(maxWidth: .infinity, alignment: .center)
            }.padding(.horizontal, 20)
        }
        //Modal
        .sheet(isPresented: $isModalShown) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Título")
                    .font(.title)

                TextField("Introduce el hábito", text: $newHabitTitle)
                    .padding(12)
                    .background(.gray.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Text("Icono")
                    .font(.title)

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(iconos, id: \.self) { icono in
                        Button {
                            newHabitIcon = icono
                        } label: {
                            Image(systemName: icono)
                                .font(.title)
                                .foregroundStyle(newHabitIcon == icono ? .blue : .black)
                                .frame(width: 50, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(newHabitIcon == icono ? .blue.opacity(0.15) : .gray.opacity(0.12))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }

                Text("Repeticiones")
                    .font(.title)

                HStack(spacing: 20) {
                    ForEach(weekIcons, id: \.self) { weekDayIcon in
                        Button {
                            if habitRepetitions.contains(weekDayIcon) {
                                habitRepetitions.removeAll { $0 == weekDayIcon }
                            } else {
                                habitRepetitions.append(weekDayIcon)
                            }
                        } label: {
                            Image(systemName: habitRepetitions.contains(weekDayIcon) ? weekDayIcon + ".fill" : weekDayIcon)
                                .font(.largeTitle)
                                .foregroundStyle(habitRepetitions.contains(weekDayIcon) ? .blue : .black)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                Spacer()
                Button {
                    createNewHabit()
                } label: {
                    Text("Crear hábito")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(20)
            .presentationDetents([.height(350)])
        }
        //Fin modal
    }
    
    private func createNewHabit() {
        
        let title = newHabitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        
        let repetitions = habitRepetitions
            .map { $0.replacingOccurrences(of: ".circle", with: "") }
            .joined(separator: ",")
        
        habits.append(
            Habit(
                title: title,
                icon: newHabitIcon.isEmpty ? "star" : newHabitIcon, repetitions: repetitions
            )
        )
        
        newHabitTitle = ""
        newHabitIcon = ""
        habitRepetitions = []
        
        
        isModalShown = false
    }
}

#Preview {
    HabitView()
}
