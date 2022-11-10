//
//  ContentView.swift
//  iDo
//
//  Created by Aleksandar Drakaliyski on 07/11/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var tasks = Tasks()
    let customColour: CustomColour
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SaveData")

    var body: some View {
        TabView {
            TasksView(filter: .none)
                .tabItem {
                    Label("All Tasks", systemImage: "tray.fill")
                }
            TasksView(filter: .done)
                .tabItem {
                    Label("Completed", systemImage: "checkmark.rectangle.fill")
                }
            
            TasksView(filter: .pending)
                .tabItem {
                    Label("Pending", systemImage: "clock.fill")
                }
            
            TaskView( customColour: CustomColour())
                .tabItem {
                    Label("Add", systemImage: "plus.app.fill")
                }
        }
        .environmentObject(tasks)
        .accentColor(customColour.theme)
    }
    
    func load() {
        do {
            let data = try Data(contentsOf: savePath)
            tasks.tasks = try JSONDecoder().decode([Task].self, from: data)
        } catch {
            tasks.tasks = []
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(tasks.tasks)
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(customColour: CustomColour())
    }
}
