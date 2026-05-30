//
//  OrdersViewModel.swift
//  billeterieScan
//
//  Created by Alice Zheng on 27/05/2026.
//

import Foundation

@MainActor
@Observable
final class OrdersViewModel {
    var isLoading: Bool = false
    var errorMessage: String?
    var orders: [GroupedTicketUsage] = []
    var success: Bool = false

    func getOrders() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            orders = try await APIClient.shared.getOrders()
        } catch APIError.unauthorized {
            errorMessage = "Veuillez vous reconnecter"
        } catch APIError.badRequest(let message) {
            errorMessage = message
        } catch APIError.transport(let underlying) {
            errorMessage = "Erreur réseau : \(underlying.localizedDescription)"
        } catch APIError.server(let status, let message) {
            errorMessage = message ?? "Erreur serveur (\(status))"
        } catch is DecodingError {
            errorMessage = "Format JSON inattendu"
        } catch {
            errorMessage = "Erreur : \(error)"
        }
    }
    
    func updateOrder(orderId: String, newQuantity: Int) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let data = try await APIClient.shared.updateOrder(orderId: orderId, newQuantity: newQuantity)
            if data.success {
                print("Update Successful")
                await getOrders()
            }
        } catch APIError.unauthorized {
            errorMessage = "Veuillez vous reconnecter"
        } catch APIError.badRequest(let message) {
            errorMessage = message
        } catch APIError.transport(let underlying) {
            errorMessage = "Erreur réseau : \(underlying.localizedDescription)"
        } catch APIError.server(let status, let message) {
            errorMessage = message ?? "Erreur serveur (\(status))"
        } catch is DecodingError {
            errorMessage = "Format JSON inattendu"
        } catch {
            errorMessage = "Erreur : \(error)"
        }
    }
}
