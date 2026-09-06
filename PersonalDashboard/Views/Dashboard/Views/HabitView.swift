//
//  HabitView.swift
//  PersonalDashboard
//
//  Created by Nachete on 27/06/2026.
//

import SwiftUI
import SwiftData

struct HabitView: View {
    
    @Environment(\.modelContext) private var modelContext
    public var isPortrait: Bool
    private let day: Date
    private let calendar: Calendar
    
    
    @Query(
            filter: #Predicate<Habit> { habit in
                habit.isActive &&
                habit.createdAt < .now
                //Intentar filtrar para que el habito no se muestre antes de la fecha de creacion
            },
            sort: \Habit.createdAt,
            order: .reverse
        )
        private var activeHabits: [Habit]

        private var todayHabits: [Habit] {
            activeHabits.filter { habit in
                habit.isScheduled(
                    on: day,
                    calendar: calendar
                )
            }
        }

        init(
            isPortrait: Bool,
            day: Date = .now,
            calendar: Calendar = .autoupdatingCurrent
        ) {
            self.isPortrait = isPortrait
            self.day = day
            self.calendar = calendar
        }
    
    ///Campos Form
    @State private var newHabitTitle: String = ""
    @State private var newHabitIcon: String = ""
    @State private var habitRepetitions: [String] = []
    @State private var isModalShown: Bool = false
    
    //Campos ocultar archivo vertical
    @State private var visibleArchiveHabitID: UUID?
    @State private var archiveHideTask: Task<Void, Never>?

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
    ///Fin Campos Form
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            HStack(alignment: .center, spacing: 8){
                Text("Hábitos")
                    .font(Font.system(size: 30, weight: .semibold))
                Image(systemName: "arrow.up.forward.square")
                    .font(.headline)
            }.padding()
                
                if(isPortrait){ ///Vista vertical
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(alignment: .center, spacing: 10){
                            ForEach(todayHabits){ habit in
                                HStack(spacing: 8) {
                                    Button{
                                        showArchiveButton(for: habit)
                                    } label: {
                                        Image(systemName: habit.icon).font(.largeTitle)
                                    }.buttonStyle(.plain)
                                        .accessibilityLabel("Mostrar opción de archivar \(habit.title)")
                                    
                                    Button{
                                        habit.toggleCompletion(
                                                on: day,
                                                in: modelContext
                                            )
                                    } label: {
                                        Image(systemName: habit.isCompleted(on: day) ? "checkmark.square.fill" : "square")
                                            .foregroundStyle(habit.isCompleted(on: day) ? .blue : .primary)
                                            .font(.largeTitle)
                                    }
                                }
                                .padding()
                                .background(.gray.opacity(0.2))
                                .clipShape(Capsule())
                                .overlay(alignment: .topLeading) {
                                    if visibleArchiveHabitID == habit.id {
                                        ArchiveUpperButton(habit: habit)
                                            .offset(x: -8, y: -8)
                                            .transition(
                                                .scale.combined(with: .opacity)
                                            )
                                    }
                                }
                            }
                            Button(action: {isModalShown = true}){
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .foregroundStyle(.primary)
                                    .padding()
                                    .background(.gray.opacity(0.2))
                                    .clipShape(Capsule())
                            }.buttonStyle(.plain)
                        }.frame(maxWidth: .infinity, alignment: .center)
                    }
                    .scrollClipDisabled()
                    .onDisappear {
                        archiveHideTask?.cancel()
                    }
                    .padding(.horizontal, 20)
                } else { ///Vista Horizontal
                        VStack(alignment: .leading, spacing: 10){
                            List {
                                ForEach(todayHabits) { habit in
                                    HStack(spacing: 8) {
                                        Button {
                                            habit.toggleCompletion(
                                                on: day,
                                                in: modelContext,
                                                calendar: calendar
                                            )
                                        } label: {
                                            Image(
                                                systemName: habit.isCompleted(
                                                    on: day,
                                                    calendar: calendar
                                                )
                                                ? "checkmark.square.fill": "square"
                                            )
                                            .foregroundStyle(
                                                habit.isCompleted(
                                                    on: day,
                                                    calendar: calendar
                                                )
                                                ? .blue: .primary
                                            )
                                            .font(.largeTitle)
                                        }
                                        .buttonStyle(.plain)

                                        Image(systemName: habit.icon)
                                            .font(.largeTitle)

                                        Text(habit.title)
                                            .font(.title2)
                                    }
                                    .padding(.vertical, 8)
                                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                        Button {
                                            habit.isActive = false
                                        } label: {
                                            Label("Archivar", systemImage: "archivebox.fill")
                                        }
                                        .tint(.yellow)
                                    }
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                }
                                Button(action: {isModalShown = true}){
                                    Image(systemName: "plus")
                                        .font(.title)
                                        .foregroundStyle(.primary)
                                    Text("Nuevo hábito")
                                }.buttonStyle(.plain)
                                    .padding(.vertical, 10)
                                    .padding(.trailing, 20)
                                    .padding(.leading)
                                    .background(.gray.opacity(0.2))
                                    .clipShape(Capsule())
                                    .padding(.horizontal, 20)
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                            }
                            .listStyle(.plain)
                            .scrollContentBackground(.hidden)
                            
                        }
                    }
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
                                .foregroundStyle(newHabitIcon == icono ? .blue : .primary)
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
                                .foregroundStyle(habitRepetitions.contains(weekDayIcon) ? .blue : .primary)
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
        .padding(.vertical, 20)
    }
    
    private func createNewHabit() {
        
        let title = newHabitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        
        let selectedDays: [Weekday] = habitRepetitions.compactMap { icon in
                switch icon {
                case "l.circle": return .monday
                case "m.circle": return .tuesday
                case "x.circle": return .wednesday
                case "j.circle": return .thursday
                case "v.circle": return .friday
                case "s.circle": return .saturday
                case "d.circle": return .sunday
                default: return nil
                }
            }

        guard !selectedDays.isEmpty else { return }
        
        modelContext.insert(
            Habit(
                title: title,
                icon: newHabitIcon.isEmpty ? "star.fill" : newHabitIcon,
                repetitionDays: selectedDays
            )
        )
        
        newHabitTitle = ""
        newHabitIcon = ""
        habitRepetitions = []
        isModalShown = false
    }
    
    private func showArchiveButton(for habit: Habit) {
        // Cancela el temporizador anterior.
        archiveHideTask?.cancel()

        withAnimation(.snappy) {
            visibleArchiveHabitID = habit.id
        }

        archiveHideTask = Task { @MainActor in
            do {
                try await Task.sleep(for: .seconds(3))
            } catch {
                // La tarea se canceló porque se tocó otro icono.
                return
            }

            guard visibleArchiveHabitID == habit.id else {
                return
            }

            withAnimation(.snappy) {
                visibleArchiveHabitID = nil
            }
        }
    }
    
}

struct ArchiveUpperButton: View {
    
    @Bindable var habit: Habit
    
    var body: some View {
        Button {
            habit.isActive = false
        } label: {
            Image(systemName: "archivebox.fill")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.black)
                .frame(width: 30, height: 30)
                .background(.yellow, in: Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Archivar hábito")

    }
}

#Preview {
    HabitView(isPortrait: true)
}
