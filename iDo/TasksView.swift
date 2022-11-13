//
//  TaskView.swift
//  iDo
//
//  Created by Aleksandar Drakaliyski on 07/11/2022.
//

import SwiftUI

struct TasksView: View {
    enum FilterType {
        case done, pending, none
    }
    
    enum SortType {
        case name, date, dateOldest
    }
    
    @EnvironmentObject var tasks: Tasks
    
    @State private var sortOrder = SortType.date
    @State private var showingConfirmationDialog = false
    @State private var showingDeleteDialog = false
    @State private var tasksAreDeleted = false
    
    @State private var feedback = UINotificationFeedbackGenerator()


    let filter: FilterType

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredTasks) { task in
                    NavigationLink(destination: EditView(task: task)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(task.name)
                                    .font(.headline)
                                    .padding(2)
                                
                                Text(task.type)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            if task.isCompleted && filter == .none {
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(2)
                        .swipeActions(edge: .leading) {
                            if task.isCompleted {
                                Button {
                                    tasks.toggle(task)
                                } label: {
                                    Label("Undo", image: "x.circle.fill")
                                }
                                .tint(.orange)
                            } else {
                                Button {
                                    tasks.toggle(task)
                                } label: {
                                    Label("Done", image: "checkmark.circle.fill")
                                }
                                .tint(.green)
                            }
                        }
                    }
                    
                }
                .onDelete(perform: removeTasks)
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        showingConfirmationDialog = true
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                    
                    Text(sortOrder == .name ? "Name" : sortOrder == .date ? "Date (Newest)" : "Date (Oldest)")
                        .onTapGesture {
                            showingConfirmationDialog = true
                        }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        if tasks.tasks.isEmpty {
                            showingDeleteDialog = false
                            tasksAreDeleted = true
                            feedback.notificationOccurred(.warning)
                        } else {
                            showingDeleteDialog = true
                            feedback.notificationOccurred(.warning)
                        }
                    } label: {
                        Label("Theme", systemImage: "trash.fill")
                            .foregroundColor(.red)
                    }
                    
                    EditButton()
                }
            }
            .confirmationDialog("Sort by...", isPresented: $showingConfirmationDialog) {
                Button("Name (A-Z)") { sortOrder = .name}
                Button("Date (Newest first)") { sortOrder = .date}
                Button("Date (Oldest first)") { sortOrder = .dateOldest}
                Button("Cancel", role: .cancel) {}
            }
            .confirmationDialog("Delete All", isPresented: $showingDeleteDialog) {
                Button("Delete All", role: .destructive) {
                    deleteAlltasks()
                }
                Button("Cancel", role: .cancel) {}
            }message: {
                Text("Are you sure you want to delete all tasks?")
            }
            .alert("There are no tasks", isPresented: $tasksAreDeleted) {
                Button("OK") {}
            }
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "All Tasks"
        case .done:
            return "Completed Tasks"
        case .pending:
            return "Pending Tasks"
        }
    }
    
    var filteredTasks: [Task] {
        let result: [Task]
        switch filter {
        case .none:
            result = tasks.tasks
        case .done:
            result = tasks.tasks.filter { $0.isCompleted }
        case .pending:
            result = tasks.tasks.filter { !$0.isCompleted }
        }
        
        if sortOrder == .name {
            return result.sorted { $0.name < $1.name}
        } else if sortOrder == .date{
            return result.reversed()
        } else {
            return result
        }
    }
    
    func removeTasks(at offsets: IndexSet) {
        if sortOrder == .date {
            let reversed = Array(tasks.tasks.reversed())
            let items = Set(offsets.map { reversed[$0].id })
            tasks.tasks.removeAll { items.contains($0.id)}
            tasks.save()
        } else if sortOrder == .name{
            let nameOrder = Array(tasks.tasks.sorted { $0.name < $1.name})
            let items = Set(offsets.map { nameOrder[$0].id })
            tasks.tasks.removeAll { items.contains($0.id)}
            
            tasks.save()
        } else {
            tasks.tasks.remove(atOffsets: offsets)
        }
    }
    
    func deleteAlltasks() {
        if tasks.tasks.isEmpty {
            showingDeleteDialog = false
            tasksAreDeleted = true
        } else {
            tasks.tasks.removeAll()
            tasks.save()
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(filter: .none)
            .environmentObject(Tasks())
    }
}
