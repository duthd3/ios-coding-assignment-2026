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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView(appContainer: AppContainer())
}
