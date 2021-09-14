//
//  MainModel.swift
//  Task100
//
//  Created by Максим Ламанский on 13.09.2021.
//

import Foundation

enum Main {
    
    struct Task: Identifiable, Hashable, Codable {
        let id: Int
        let text: String
    }
    
}
