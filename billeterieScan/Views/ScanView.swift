//
//  ScanView.swift
//  billeterieScan
//
//  Created by Alice Zheng on 27/05/2026.
//
import SwiftUI

struct ScanView: View {
    @AppStorage("authToken") private var authToken: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Scan view")
                    .font(.largeTitle)
                    .bold()

                Button("logout") {
                    authToken = nil
                    UserDefaults.standard.removeObject(forKey: "authToken")
                }
            }
            .padding()
        }
    }
}

#Preview {
    ScanView()
}
