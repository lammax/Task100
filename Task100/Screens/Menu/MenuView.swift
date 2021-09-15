//
//  MenuView.swift
//  Task100
//
//  Created by Максим Ламанский on 15.09.2021.
//

import SwiftUI

struct MenuView: View {
    
    @EnvironmentObject var coordinator: RootCoordinator
    @Environment(\.colorScheme) var colorScheme
    
    @State private var text: String = ""
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter list name", text: $text) { _ in
                } onCommit: {
                    coordinator.updateMenuList(with: text)
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
            .navigationTitle(coordinator.taskList.title)
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
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
