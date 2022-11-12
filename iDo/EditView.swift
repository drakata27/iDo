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
    
    let typeOptions: [String] = [
        "University", "Work", "Self-Improvement", "Groceries", "Personal", "Fitness","Programming", "Other"
    ]
    @State private var selectedTypeOption = "Other"
    
    var body: some View {
        Form {
            VStack {
                    HStack {
                        Text("Current task:")
                            .font(.headline)
                        Text(task.name)
                            .font(.headline)
                            .foregroundColor(customColour.theme)
                        Spacer()
                    }
                    .padding()
                        
                    TextField("Task name", text: $name)
                        .font(.title)
                        .focused($isFocused)
                        .padding(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(customColour.theme, lineWidth: 2)
                            )
                    HStack {
                        Text("Type:")
                            .font(.headline)
                        Text(task.type)
                            .font(.headline)
                            .foregroundColor(customColour.theme)

                        Spacer()
                    }
                    .padding()
                    
                    VStack {
                        TextField("Type", text: $type)
                            .font(.title)
                            .focused($isFocused)
                            .padding(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(customColour.theme, lineWidth: 2)
                                )
                        
                        Picker("Select type", selection: $selectedTypeOption) {
                            ForEach(typeOptions, id: \.self) { option in
                                Text(option)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .onChange(of: selectedTypeOption) { newValue in
                            type = selectedTypeOption
                        }
                    }
                    
                    Button {
                        saveChanges()
                    } label: {
                        Text("Save")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .buttonStyle(BlueButton())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                .environmentObject(tasks)
        }
    }
    
    func saveChanges() {
        if name.isEmpty {
            taskIsEmpty = true
            feedback.notificationOccurred(.error)
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
