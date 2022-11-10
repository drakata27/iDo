//
//  TaskView.swift
//  iDo
//
//  Created by Aleksandar Drakaliyski on 07/11/2022.
//

import SwiftUI

struct BlueButton: ButtonStyle {
    @State private var customColour = CustomColour()
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(customColour.theme)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct TaskView: View {
    @EnvironmentObject var tasks: Tasks
    
    @State private var name = ""
    @State private var type = ""
    @State private var isAdded = false
    @State private var taskIsEmpty = false
    
    let typeOptions: [String] = [
        "University", "Work", "Self-Improvement", "Groceries", "Personal", "Fitness", "Other"
    ]
    @State private var selectedTypeOption = "Other"
    
    @State private var feedback = UINotificationFeedbackGenerator()
    @FocusState private var isFocused: Bool
    let customColour: CustomColour
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Task name", text: $name)
                    .font(.title)
                    .focused($isFocused)
                    .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(customColour.theme, lineWidth: 2)
                        )
                        .padding()
                    
                HStack {
                    TextField("Task type", text: $type)
                        .font(.title)
                        .focused($isFocused)
                        .padding(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(customColour.theme, lineWidth: 2)
                            )
                        .padding()
                    
                    Picker("Please choose a color", selection: $selectedTypeOption) {
                        ForEach(typeOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .onChange(of: selectedTypeOption) { newValue in
                        type = selectedTypeOption
                    }
                }
                
                Button {
                    addTask()
                } label: {
                    Text("Done")
                        .foregroundColor(.white)
                }
                .padding()
                .buttonStyle(BlueButton())
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .environmentObject(tasks)
            .navigationTitle("Create a task")
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
            .alert("Task added", isPresented: $isAdded) {
                Button("Ok"){}
            }
            .alert("Task is empty", isPresented: $taskIsEmpty) {
                Button("OK"){}
            } message: {
                Text("Please add a task")
            }
        }
    }
    
    func addTask() {
        let element = Task(name: name, type: type)
        
        if element.name.isEmpty {
            taskIsEmpty = true
        } else {
            tasks.add(element)
            name = ""
            type = ""
            isAdded = true
            feedback.notificationOccurred(.success)
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(customColour: CustomColour())
            .environmentObject(Tasks())
    }
}
