//
//  Task.swift
//  iDo
//
//  Created by Aleksandar Drakaliyski on 07/11/2022.
//

import SwiftUI

class Task: Identifiable, Codable {
    var id = UUID()
    var name: String
    var type: String
    var isCompleted = false
    
    init(id: UUID = UUID(), name: String, type: String, isCompleted: Bool = false) {
        self.id = id
        self.name = name
        self.type = type
        self.isCompleted = isCompleted
    }
}

@MainActor class Tasks: ObservableObject {
    @Published var tasks: [Task]
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedData")

    init() {
        do {
            let data = try Data(contentsOf: savePath)
            tasks = try JSONDecoder().decode([Task].self, from: data)
        } catch {
            tasks = []
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(tasks)
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
    
    func add(_ task: Task) {
        tasks.append(task)
        save()
    }
    
    func toggle(_ task: Task) {
        objectWillChange.send()
        task.isCompleted.toggle()
        save()
    }
}

struct CustomColour {
   let theme = Color(red: 0/255, green: 190/255, blue: 255/255)
}
