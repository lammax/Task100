//
//  MainInteractor.swift
//  Task100
//
//  Created by Максим Ламанский on 14.09.2021.
//

import Foundation

class MainInteractor {
    
    func save(list: Main.TaskList) {
        UserDefaults.taskList = list
    }
    
    func getTaskList() -> Main.TaskList {
        UserDefaults.taskList
    }
}
