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
                    ForEach(coordinator.menuList, id: \.self) { listName in
                        Text(listName)
                            .onTapGesture {
                                if editMode == .active {
                                    text = listName
                                    coordinator.edit(menuItem: listName)
                                } else {
                                    coordinator.choose(menuItem: listName)
                                }
                            }
                    }
                    .onDelete(perform: coordinator.deleteMenuItem)
                    .onMove(perform: coordinator.moveMenuItem)
                }
                
            }
            .environment(\.editMode, $editMode)
            .navigationBarItems(leading: editButton, trailing: saveButton)
            .navigationTitle("Списки 100")
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
        coordinator.saveMenuList()
    }
    
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
