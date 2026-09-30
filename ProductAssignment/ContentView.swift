//
//  ContentView.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

import SwiftUI

struct ContentView: View {
    let appContainer: AppContainer

    var body: some View {
        ProductListView(appContainer: appContainer)
    }
}

#Preview {
    ContentView(appContainer: AppContainer())
}
