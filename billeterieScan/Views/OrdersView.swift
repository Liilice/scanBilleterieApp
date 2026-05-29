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
                header
                ordersList
            }
            .padding()
            .background(Color.bgBlack.ignoresSafeArea())
            .overlay {
                if ordersVM.isLoading {
                    loadingOverlay
                }
            }
            .alert("Erreur", isPresented: errorBinding) {
                Button("OK", role: .cancel) {
                    ordersVM.errorMessage = nil
                }
            } message: {
                Text(ordersVM.errorMessage ?? "")
            }
            .task {
                await ordersVM.getOrders()
            }
        }
    }

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            ProgressView()
                .scaleEffect(1.8)
                .tint(.white)
                .padding(40)
                .background(Color(white: 0.15))
                .cornerRadius(20)
        }
        .zIndex(1000)
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { ordersVM.errorMessage != nil },
            set: { if !$0 { ordersVM.errorMessage = nil } }
        )
    }

    private var header: some View {
        HStack(spacing: 24) {
            Image(systemName: "music.note")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(R.color.primaryLight))
            Spacer()
            Text("orders")
                .font(.largeTitle)
                .foregroundStyle(Color(R.color.primaryLight))
                .font(.system(size: 24, weight: .bold))
            Spacer()
            Button {
                authToken = nil
                UserDefaults.standard.removeObject(forKey: "authToken")
            } label: {
                Image(systemName: "iphone.and.arrow.forward.outward")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color(R.color.primaryLight))

            }
        }
    }

    private func dateHeader(_ date: String) -> some View {
        HStack {
            Image(systemName: "calendar")
                .bold()
                .foregroundStyle(Color(R.color.primaryLight))
            Text(date)
                .bold()
                .foregroundStyle(Color(R.color.primaryLight))
                .font(.system(size: 20, weight: .regular))
                .tracking(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var ordersList: some View {
        List {
            ForEach(ordersVM.orders, id: \.concertDate) { group in
                dateHeader(group.concertDate)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                ForEach(group.tickets) { order in
                    OrderRow(order: order, ordersVM: ordersVM)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                }
            }
        }
        .listStyle(.plain)
        .listRowSpacing(12)
        .scrollContentBackground(.hidden)
        .background(Color.bgBlack)
    }
}

struct OrderRow: View {
    let order: OrdersResponse
    let ordersVM: OrdersViewModel

    var body: some View {
        HStack {
            infoColumn
            Spacer()
            quantityControls
        }
        .padding()
        .background(Color(hex: "#211F1F"))
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(Color.red)
                .frame(width: 5)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: "#373636"), lineWidth: 2)
        )
    }

    private var infoColumn: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(order.name)
                .foregroundStyle(Color(R.color.tertiary))
                .bold()
            Text(order.email)
                .foregroundStyle(Color(R.color.tertiary))
                .font(.caption)
            Text("\(order.concertDate)  \(order.concertTime)")
                .foregroundStyle(Color(R.color.tertiary))
                .font(.caption)
        }
    }

    private var quantityControls: some View {
        HStack(spacing: 12) {
            Button {
                if order.quantities > 0 {
                    Task {
                        await ordersVM.updateOrder(orderId: order.id, newQuantity: order.quantities - 1)
                    }
                }
            } label: {
                Image(systemName: "minus")
                    .bold()
                    .foregroundStyle(Color(R.color.primaryLight))
            }
            .buttonStyle(.plain)
            .disabled(order.quantities <= 0 ? true : false)

            Text("\(order.quantities)")
                .foregroundStyle(Color(R.color.tertiary))
                .bold()

            Button {
                if order.quantities < order.quantitiesBuy {
                    Task {
                        await ordersVM.updateOrder(orderId: order.id, newQuantity: order.quantities + 1)
                    }
                }
            } label: {
                Image(systemName: "plus")
                    .bold()
                    .foregroundStyle(Color(R.color.primary))
            }
            .buttonStyle(.plain)
            .disabled(order.quantities >= order.quantitiesBuy ? true : false)
        }
        .padding()
        .background(Color(R.color.neutral))
        .cornerRadius(50)
    }
}

#Preview {
    OrdersView()
}
