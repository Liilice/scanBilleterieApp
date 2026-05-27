//
//  ContentView.swift
//  billeterieScan
//
//  Created by Alice Zheng on 18/05/2026.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("authToken") private var authToken: String?

    var body: some View {
        if let authToken, !authToken.isEmpty {
            MainTabView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
