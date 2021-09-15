//
//  ContentView.swift
//  Task100
//
//  Created by Максим Ламанский on 13.09.2021.
//

import SwiftUI

struct TaskListView: View {
    
    @EnvironmentObject var coordinator: RootCoordinator
    @Environment(\.colorScheme) var colorScheme
    
    @State private var text: String = ""
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your task", text: $text) { _ in
                } onCommit: {
                    coordinator.updateTaskList(with: text)
                    text = ""
                }
                .padding(.horizontal)

                List {
                    ForEach(coordinator.taskList.tasks, id: \.self) { task in
                        Text(task.text)
                            .onTapGesture {
                                text = task.text
                                coordinator.currentEditTask = task
                            }
                    }
                    .onDelete(perform: coordinator.deleteTask)
                    .onMove(perform: coordinator.moveTask)
                }
                
            }
            .environment(\.editMode, $editMode)
            .navigationBarItems(leading: editButton, trailing: saveButton)
            .navigationTitle(coordinator.taskList.title + " (\(coordinator.taskList.tasks.count))")
        }
    }
    
    private var editButton: some View {
        return AnyView(Button(action: onEdit) { Image(systemName: "pencil").padding(.all, 5).background(Color.yellow) })
    }

    private var saveButton: some View {
        return AnyView(Button(action: onSave) { Image(systemName: "square.and.arrow.down").padding(.all, 5).background(Color.yellow) })
    }
    
    func onEdit() {
        if editMode == .active {
            editMode = .inactive
        } else {
            editMode = .active
        }
    }
    
    func onSave() {
        coordinator.saveTaskList()
        coordinator.back()
    }
    
    
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
