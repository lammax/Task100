//
//  RootView.swift
//  Task100
//
//  Created by Максим Ламанский on 15.09.2021.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var coordinator: RootCoordinator
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if #available(iOS 14.0, *) {
            coordinator.currentScene
                .ignoresSafeArea(.all, edges: .top)
        } else {
            coordinator.currentScene
                .edgesIgnoringSafeArea(.top)
        }
    }
    
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
