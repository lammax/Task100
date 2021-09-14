//
//  ContentView.swift
//  Task100
//
//  Created by Максим Ламанский on 13.09.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var tasks: [Main.Task] = []
    @State private var text: String = ""
    @State private var currentEditTask: Main.Task?
    @State private var editMode = EditMode.inactive
    
    let interactor = MainInteractor()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Task", text: $text) { _ in
                } onCommit: {
                    if let curTask = currentEditTask {
                        let oldTaskID: Int = tasks.firstIndex(where: { $0.id == curTask.id }) ?? 0
                        tasks[oldTaskID] = Main.Task(id: oldTaskID, text: "\(oldTaskID + 1)) \(text)")
                    } else {
                        tasks.append(Main.Task(id: tasks.count, text: "\(tasks.count + 1)) \(text)"))
                    }
                    onSave()
                    text = ""
                }
                .padding(.horizontal)

                List {
                    ForEach(tasks, id: \.self) { task in
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
            .navigationTitle("Tasks")
        }
        .onAppear {
            tasks = interactor.getTaskList()
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
        interactor.save(list: tasks)
    }
    
    func delete(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        onSave()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
        onSave()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
