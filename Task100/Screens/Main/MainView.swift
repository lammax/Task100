//
//  ContentView.swift
//  Task100
//
//  Created by Максим Ламанский on 13.09.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var tasks: [Main.Task] = [Main.Task(text: "1st task"), Main.Task(text: "2nd task")]
    @State private var text: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Task", text: $text) { isEdit in
                    print(isEdit)
                } onCommit: {
                    tasks.append(Main.Task(text: text))
                    text = ""
                }
                .padding(.horizontal)

                List {
                    ForEach(tasks, id: \.self) { task in
                        Text(task.text)
                    }
                    .onDelete(perform: delete)
                }
            }
            .toolbar {
                EditButton()
            }
            .navigationTitle("Tasks")
        }
    }
    
    func delete(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
