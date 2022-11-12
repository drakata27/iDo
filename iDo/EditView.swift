//
//  EditView.swift
//  iDo
//
//  Created by Aleksandar Drakaliyski on 12/11/2022.
//

import SwiftUI

struct EditView: View {
    var task: Task
    let customColour = CustomColour()
    @FocusState private var isFocused: Bool
    
    @State private var name = ""
    @State private var type = ""
    
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
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(task: Task.example)
    }
}
