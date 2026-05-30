//
//  APIClient.swift
//  billeterieScan
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
    case badRequest(message: String)
    case server(status: Int, message: String?)
    case decoding(Error)
    case transport(Error)
}

private struct APIErrorBody: Decodable {
    let error: String
}

private func decodeErrorMessage(from data: Data) -> String? {
    return try? JSONDecoder().decode(APIErrorBody.self, from: data).error
}

final class APIClient {
    static let shared = APIClient()
    private let baseURL = URL(string: "https://chorale-de-bons-choeurs-f7hr.vercel.app/api/")!
    private let session = URLSession.shared

    private var authToken: String? {
        UserDefaults.standard.string(forKey: "authToken")
    }

    func login(password: String) async throws -> String {
        let url = baseURL.appendingPathComponent("admin/connect")
        print("url \(url)")
        print("password \(password)")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(LoginRequest(password: password))

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.transport(error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch http.statusCode {
        case 200..<300:
            do {
                return try JSONDecoder().decode(LoginResponse.self, from: data).token
            } catch {
                throw APIError.decoding(error)
            }
        case 401:
            throw APIError.unauthorized
        case 400..<500:
            throw APIError.badRequest(message: decodeErrorMessage(from: data) ?? "Requête invalide")
        default:
            throw APIError.server(status: http.statusCode, message: decodeErrorMessage(from: data))
        }
    }

    func getOrders() async throws -> [GroupedTicketUsage] {
        let url = baseURL.appendingPathComponent("admin/ticketUsage")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let authToken {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.transport(error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch http.statusCode {
        case 200..<300:
            do {
                return try JSONDecoder().decode([GroupedTicketUsage].self, from: data)
            } catch {
                throw APIError.decoding(error)
            }
        case 401:
            throw APIError.unauthorized
        case 400..<500:
            throw APIError.badRequest(message: decodeErrorMessage(from: data) ?? "Requête invalide")
        default:
            throw APIError.server(status: http.statusCode, message: decodeErrorMessage(from: data))
        }
    }

    func updateOrder(orderId: String, newQuantity: Int) async throws -> OrderUpdateResponse {
        let url = baseURL.appendingPathComponent("admin/ticketUsage")
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authToken {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try JSONEncoder().encode(OrderUpdateRequest(id: orderId, quantities: newQuantity))
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.transport(error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch http.statusCode {
        case 200..<300:
            do {
                return try JSONDecoder().decode(OrderUpdateResponse.self, from: data)
            } catch {
                throw APIError.decoding(error)
            }
        case 401:
            throw APIError.unauthorized
        case 400..<500:
            throw APIError.badRequest(message: decodeErrorMessage(from: data) ?? "Requête invalide")
        default:
            throw APIError.server(status: http.statusCode, message: decodeErrorMessage(from: data))
        }
    }
}
