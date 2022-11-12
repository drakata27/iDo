//
//  EditView.swift
//  iDo
//
//  Created by Aleksandar Drakaliyski on 12/11/2022.
//

import SwiftUI

struct EditView: View {
    var task: Task
    @EnvironmentObject var tasks: Tasks

    let customColour = CustomColour()
    @FocusState private var isFocused: Bool
    @State private var feedback = UINotificationFeedbackGenerator()
    
    @State private var name = ""
    @State private var type = ""
    @State private var isUpdated = false
    @State private var taskIsEmpty = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Task: \(task.name)")
                TextField("Task name", text: $name)
                    .font(.title)
                    .focused($isFocused)
                    .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(customColour.theme, lineWidth: 2)
                        )
                        .padding()
                
                Text("Type: \(task.type)")
                TextField("Type", text: $type)
                    .font(.title)
                    .focused($isFocused)
                    .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(customColour.theme, lineWidth: 2)
                        )
                        .padding()
                
                Button {
                    saveChanges()
                } label: {
                    Text("Save")
                        .foregroundColor(.white)
                }
                .padding()
                .buttonStyle(BlueButton())
                .frame(maxWidth: .infinity)
                Spacer()

            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        isFocused = false
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .foregroundColor(customColour.theme)
                    }
                }
            }
            .alert("Task is updated!", isPresented: $isUpdated) {
                Button("OK"){}
            }
            .alert("Task is empty", isPresented: $taskIsEmpty) {
                Button("OK"){}
            } message: {
                Text("Please add a task")
            }
        }
        .environmentObject(tasks)
    }
    
    func saveChanges() {
        if name.isEmpty {
            taskIsEmpty = true
        } else {
            
            task.name = name
            task.type = type
            feedback.notificationOccurred(.success)
            
            isUpdated = true
            name.removeAll()
            type.removeAll()
            tasks.save()
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(task: Task.example)
            .environmentObject(Tasks())
    }
}
