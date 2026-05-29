//
//  MainTabView.swift
//  billeterieScan
//
//  Created by Alice Zheng on 27/05/2026.
//
import SwiftUI

struct MainTabView: View {
    @AppStorage("authToken") private var authToken: String?

    enum Tabs {
        case orders
        case scan
    }
    @State var tabSelection: Tabs = .orders
    var body: some View {
        TabView(selection: $tabSelection, content: {
            OrdersView()
                .tabItem {
                    Label("tabs.orders", systemImage: "list.clipboard")
                }
                .toolbarBackground(Color(white: 0.15), for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
            ScanView()
                .tabItem {
                    Label("tabs.scan", systemImage: "qrcode.viewfinder")
                }
                .toolbarBackground(Color(white: 0.15), for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
        })
    }
}

#Preview {
    MainTabView()
}
