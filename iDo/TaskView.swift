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
    
    @State private var feedback = UINotificationFeedbackGenerator()
    @FocusState private var isFocused: Bool
    let customColour: CustomColour
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Task name", text: $name)
                    .font(.title)
                    .focused($isFocused)
                    
                TextField("Task type", text: $type)
                    .font(.title)
                    .focused($isFocused)
                
        
                Button {
                    addTask()
                } label: {
                    Text("Done")
                        .foregroundColor(.white)
                }
                .padding()
                .buttonStyle(BlueButton())
                .frame(maxWidth: .infinity)
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
