//
//  CoordinatorSwiftUI.swift
//  Task100
//
//  Created by Максим Ламанский on 15.09.2021.
//

import Foundation
import SwiftUI

protocol CoordinatorSwiftUI {
    
    var navCoordinator: NavigatorSwiftUI { get set }
    var currentScene: AnyView { get set }
    
    func start()
    func back(completion: (() -> Void)?)
    
}

