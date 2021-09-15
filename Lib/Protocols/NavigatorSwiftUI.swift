//
//  NavigatorSwiftUI.swift
//  Task100
//
//  Created by Максим Ламанский on 15.09.2021.
//

import Foundation

protocol NavigatorSwiftUI {
    
    var currentCoordinator: CoordinatorSwiftUI? { get set }
    
    var previousCoordinators: [CoordinatorSwiftUI] { get set }
    
    func push(_ coordinator: CoordinatorSwiftUI)

    func pop()
    
    func clear()
    
    func allCoordinators() -> [CoordinatorSwiftUI?]
    
}

protocol NavigatorGeneric {
    
    associatedtype Typ
    
    var current: Typ? { get set }
    
    var previous: [Typ] { get set }
    
    func push(_ coordinator: Typ)

    func pop()
    
    func clear()
    
    func allScenes() -> [Typ?]
    
}

