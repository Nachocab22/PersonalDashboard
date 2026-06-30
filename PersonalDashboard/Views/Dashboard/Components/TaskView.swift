//
//  TaskView.swift
//  PersonalDashboard
//
//  Created by Nachete on 27/06/2026.
//

import SwiftUI

struct TaskView: View {
    
    struct Task : Identifiable {
        let id: UUID = UUID()
        var title: String
        var isCompleted: Bool = false
        var isUrgent: Bool = false
        var isDeleted: Bool = false
    }
    
    @State var tasks: [Task] = [
        Task(title: "Hacer pantalla transacciones KORA", isUrgent: true),
        Task(title: "Arreglar tamaño vista de tareas", isCompleted: true),
        Task(title: "Adaptar a modo landscape", isUrgent: true),
        Task(title: "Ejecutar desarrollo en iPad físico para probar el correcto funcionamiento del aplicación")
    ]
    
    @State var newTaskTitle: String = ""
    @FocusState private var isNewTaskFocused : Bool
    
    var body: some View {
        
        var urgentTaskIndices: [Int] {
            tasks.indices.filter {
                tasks[$0].isUrgent && !tasks[$0].isDeleted
            }
        }

        var normalTaskIndices: [Int] {
            tasks.indices.filter {
                !tasks[$0].isUrgent && !tasks[$0].isDeleted
            }
        }
        
        VStack(alignment: .leading){
            Text("Tareas")
                .font(Font.system(size: 30, weight: .semibold))
                .padding()
            List {
                ForEach(urgentTaskIndices, id: \.self) { index in
                    TaskRow(task: $tasks[index])
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        .listRowBackground(
                            Rectangle()
                                .fill(.yellow.opacity(0.5))
                                .padding(.vertical, 0)
                                .padding(.horizontal, 8)
                        )
                }
                ForEach(normalTaskIndices, id: \.self) { index in
                    TaskRow(task: $tasks[index])
                        .listRowSeparator(.hidden)
                }
                HStack(alignment: .firstTextBaseline){
                    Image(systemName: "circle.dotted").opacity(0.5)
                        .font(.title2)
                    TextField("", text: $newTaskTitle)
                        .focused($isNewTaskFocused)
                        .onSubmit {
                            addNewTask()
                        }
                        .onChange(of: isNewTaskFocused) { oldValue, newValue in
                            if oldValue == true && newValue == false {
                                addNewTask()
                            }
                        }
                }.listRowSeparator(.hidden)
                
            }.listStyle(.plain)
            
        }
    }
    
    private func addNewTask() {
        let title = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !title.isEmpty else { return }
        
        tasks.append(Task(title: title))
        newTaskTitle = ""
    }
    
}

#Preview {
    TaskView()
}

struct TaskRow: View {
    
    @Binding var task: TaskView.Task
    
    var body: some View {
        HStack {
            Button(action: {
                task.isCompleted.toggle()
            }) {
                Image(systemName: task.isCompleted ? "inset.filled.circle" : "circle").foregroundStyle(task.isCompleted ? task.isUrgent ? .orange : .blue : .black)
                    .font(.title2)
            }.buttonStyle(.plain)
            TextField(task.title, text: $task.title)
                .font(Font.system(size: 18))
                .strikethrough(task.isCompleted)
                
        }.swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                task.isDeleted.toggle()
            } label: {
                Label("Eliminar", systemImage: "trash"
                )
            }.tint(.red)
            Button {
                task.isUrgent.toggle()
            } label: {
                Label(
                    task.isUrgent ? "No urgente" : "Urgente",
                    systemImage: task.isUrgent ? "xmark.octagon" : "exclamationmark.octagon"
                )
            }.tint(task.isUrgent ? .gray : .orange)
        }.frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
    }
}
