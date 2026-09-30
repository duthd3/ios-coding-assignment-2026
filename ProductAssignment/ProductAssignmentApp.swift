//
//  ProductAssignmentApp.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

import SwiftUI

@main
struct ProductAssignmentApp: App {
    @State private var appContainer = AppContainer()

    var body: some Scene {
        WindowGroup {
            ContentView(appContainer: appContainer)
        }
    }
}
