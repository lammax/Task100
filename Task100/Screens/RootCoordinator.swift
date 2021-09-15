//
//  RootCoordinator.swift
//  Task100
//
//  Created by Максим Ламанский on 15.09.2021.
//

import Combine
import SwiftUI

class RootCoordinator: ObservableObject, CoordinatorSwiftUI {
    
    @Published var currentScene: AnyView = AnyView(EmptyView())
    @Published var taskList: Root.TaskList = Root.TaskList.defaultList
    @Published var menuList: [String] = []
    
    var currentEditTask: Root.Task?
    var currentEditMenuItem: String?

    internal var cancellables: [AnyCancellable] = []

    internal var navScene = NavigationControllerGeneric<Root.Flow>()
    internal var navCoordinator: NavigatorSwiftUI
    
    init(navigator: NavigatorSwiftUI) {
        self.navCoordinator = navigator
        setupCoordinator()
        setupBindings()
        self.start()
    }
    
    private func clearAllSubscriptions() {
        var self2 = self
        self2.clearSubscriptions()
    }
    
    private func setupCoordinator() {
        navCoordinator.push(self)
    }
    
    func start() {
        loadMenuList()
        showMainMenu()
    }
    
    func back(completion: (() -> Void)? = nil) {
        navScene.pop()
        if navScene.current == nil {
            weak var self2 = self
            self2?.clearAllSubscriptions()
            self2?.navCoordinator.pop()
            self2?.navCoordinator.currentCoordinator?.back(completion: nil)
        }
        completion?()
    }
    
    private func loadMenuList() {
        menuList = UserDefaults.menuList
    }
    
    private func showScene(for flow: Root.Flow) {
        switch flow {
        case .menu: currentScene = AnyView(MenuView().environmentObject(self))
        case .taskList: currentScene = AnyView(TaskListView().environmentObject(self))
        }
    }
    
    func showMainMenu() {
        menuList = getMenuList()
        show(menu: .menu)
    }

    func showTaskList(for key: String) {
        taskList = getTaskList(for: key)
        show(menu: .taskList)
    }

    func show(menu item: Root.Flow) {
        navScene.push(item)
    }
    
}

extension RootCoordinator: Bindable {
    internal func setupBindings() {
        let sceneStateCancellable = navScene.$current.sink(receiveValue: { [weak self] value in
            guard let self = self, let sceneFlow = value else { return }
            self.showScene(for: sceneFlow)
        })
        
        cancellables.append(sceneStateCancellable)
    }
}

extension RootCoordinator {
    
    func getTaskList(for key: String) -> Root.TaskList {
        UserDefaults.getObject(for: key, castTo: Root.TaskList.self) ?? Root.TaskList .defaultList
    }

    func getMenuList() -> [String] {
        UserDefaults.menuList
    }

    func save(taskList: Root.TaskList, for key: String) {
        UserDefaults.setObject(taskList, for: key)
    }

    func saveTaskList() {
        save(taskList: taskList, for: taskList.title)
    }

    func saveMenuList() {
        UserDefaults.menuList = menuList
    }

    func updateTaskList(with task: String) {
        var tasks = taskList.tasks
        if let curTask = currentEditTask {
            let oldTaskID: Int = taskList.tasks.firstIndex(where: { $0.id == curTask.id }) ?? 0
            tasks[oldTaskID] = Root.Task(id: oldTaskID, text: "\(oldTaskID + 1)) \(task)")
            currentEditTask = nil
        } else {
            tasks.append(Root.Task(id: tasks.count, text: "\(tasks.count + 1)) \(task)"))
        }
        taskList = Root.TaskList(title: taskList.title, tasks: tasks)
        
        saveTaskList()
    }

    func updateMenuList(with item: String) {
        if let menuItem = currentEditMenuItem {
            let oldMenuItemID: Int = menuList.firstIndex(where: { $0 == menuItem }) ?? 0
            menuList[oldMenuItemID] = item
            currentEditMenuItem = nil
        } else {
            menuList.append(item)
        }
        saveMenuList()
    }

    func deleteTask(at offsets: IndexSet) {
        var tasks = taskList.tasks
        tasks.remove(atOffsets: offsets)
        taskList = Root.TaskList(title: taskList.title, tasks: tasks)
        saveTaskList()
    }
    
    func moveTask(from source: IndexSet, to destination: Int) {
        var tasks = taskList.tasks
        tasks.move(fromOffsets: source, toOffset: destination)
        taskList = Root.TaskList(title: taskList.title, tasks: tasks)
        saveTaskList()
    }

}
