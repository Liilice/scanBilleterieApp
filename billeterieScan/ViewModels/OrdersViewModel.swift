//
//  OrdersViewModel.swift
//  billeterieScan
//
//  Created by Alice Zheng on 27/05/2026.
//

import Foundation

@Observable
final class OrdersViewModel {
    var isLoading: Bool = false
    var errorMessage: String?
    var orders: [OrdersResponse] = []

    func getOrders() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            orders = try await APIClient.shared.getOrders()
        } catch APIError.unauthorized {
            errorMessage = "Veuillez vous reconnecter"
        } catch APIError.transport(let underlying) {
            errorMessage = "Erreur réseau : \(underlying.localizedDescription)"
        } catch APIError.server(let status) {
            errorMessage = "Erreur serveur (\(status))"
        } catch is DecodingError {
            errorMessage = "Format JSON inattendu"
        } catch {
            errorMessage = "Erreur : \(error)"
        }
    }
}
