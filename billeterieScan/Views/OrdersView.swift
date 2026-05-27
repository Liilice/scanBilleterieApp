//
//  CommandesView.swift
//  billeterieScan
//

import SwiftUI

struct OrdersView: View {
    @AppStorage("authToken") private var authToken: String?
    @State private var ordersVM = OrdersViewModel()
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("orders")
                    .font(.largeTitle)
                    .bold()

                if ordersVM.isLoading {
                    ProgressView()
                }

                if let error = ordersVM.errorMessage {
                    Text(error).foregroundStyle(.red)
                }

                Text("\(ordersVM.orders.count) commande(s)")

                Button("logout") {
                    authToken = nil
                    UserDefaults.standard.removeObject(forKey: "authToken")
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            .padding()
            .task {
                await ordersVM.getOrders()
            }
        }
    }
}

#Preview {
    OrdersView()
}
