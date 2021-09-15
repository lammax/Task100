//
//  Bindable.swift
//  Task100
//
//  Created by Максим Ламанский on 15.09.2021.
//

import Foundation
import Combine

protocol Bindable {
    var cancellables: [AnyCancellable] { get set }
    
    func setupBindings()
}

extension Bindable {

    mutating func clearSubscriptions() {
        cancellables.forEach({ $0.cancel() })
        cancellables = []
    }

}
