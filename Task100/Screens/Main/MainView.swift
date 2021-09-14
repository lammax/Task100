//
//  ContentView.swift
//  Task100
//
//  Created by Максим Ламанский on 13.09.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var taskList: Main.TaskList = Main.TaskList(title: "Люблю делать", tasks: [])
    @State private var text: String = ""
    @State private var currentEditTask: Main.Task?
    @State private var editMode = EditMode.inactive
    
    let interactor = MainInteractor()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your task", text: $text) { _ in
                } onCommit: {
                    var tasks = taskList.tasks
                    if let curTask = currentEditTask {
                        let oldTaskID: Int = taskList.tasks.firstIndex(where: { $0.id == curTask.id }) ?? 0
                        tasks[oldTaskID] = Main.Task(id: oldTaskID, text: "\(oldTaskID + 1)) \(text)")
                    } else {
                        tasks.append(Main.Task(id: tasks.count, text: "\(tasks.count + 1)) \(text)"))
                    }
                    taskList = Main.TaskList(title: taskList.title, tasks: tasks)
                    onSave()
                    text = ""
                }
                .padding(.horizontal)

                List {
                    ForEach(taskList.tasks, id: \.self) { task in
                        Text(task.text)
                            .onTapGesture {
                                text = task.text
                                currentEditTask = task
                            }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
                
            }
            .environment(\.editMode, $editMode)
            .navigationBarItems(leading: editButton, trailing: saveButton)
            .navigationTitle(taskList.title)
        }
        .onAppear {
            taskList = interactor.getTaskList()
            taskList = Main.TaskList(title: taskList.title.isEmpty ? "Люблю делать2" : taskList.title, tasks: taskList.tasks)
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
        interactor.save(list: taskList)
    }
    
    func delete(at offsets: IndexSet) {
        var tasks = taskList.tasks
        tasks.remove(atOffsets: offsets)
        taskList = Main.TaskList(title: taskList.title, tasks: tasks)
        onSave()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        var tasks = taskList.tasks
        tasks.move(fromOffsets: source, toOffset: destination)
        taskList = Main.TaskList(title: taskList.title, tasks: tasks)
        onSave()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
