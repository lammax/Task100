//
//  RootModel.swift
//  Task100
//
//  Created by Максим Ламанский on 15.09.2021.
//

import Foundation

enum Root {
    
    enum Flow {
        case menu
        case taskList
    }
    
    struct Task: Identifiable, Hashable, Codable {
        let id: Int
        let text: String
    }
    
    struct TaskList: Codable {
        let title: String
        let tasks: [Task]
        
        static let defaultList = TaskList(title: "", tasks: [])
    }
    
    struct List: Codable {
        let items: [TaskList]
    }
    
}
