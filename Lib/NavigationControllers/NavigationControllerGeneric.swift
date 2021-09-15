//
//  NavigationControllerGeneric.swift
//  Task100
//
//  Created by Максим Ламанский on 15.09.2021.
//

import Foundation
import Combine

class NavigationControllerGeneric<T>: ObservableObject, NavigatorGeneric {
    
    @Published var current: T?
    
    internal var previous: [T] = []
    
    func push(_ item: T) {
        if let prev = self.current {
            previous.append(prev)
        }
        self.current = item
    }

    func pop() {
        self.current = previous.popLast()
    }
    
    func clear() {
        self.previous.removeAll()
        self.current = nil
    }
    
    func allScenes() -> [T?] {
        previous + [current]
    }
    
}
