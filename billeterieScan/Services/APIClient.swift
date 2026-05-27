//
//  APIClient.swift
//  billeterieScan
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
    case server(status: Int)
    case decoding(Error)
    case transport(Error)
}

final class APIClient {
    static let shared = APIClient()
    private let baseURL = URL(string: "http://localhost:3000/api")!
    private let session = URLSession.shared

    private var authToken: String? {
        UserDefaults.standard.string(forKey: "authToken")
    }

    func login(password: String) async throws -> String {
        let url = baseURL.appendingPathComponent("admin/connect")
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
        default:
            throw APIError.server(status: http.statusCode)
        }
    }

    func getOrders() async throws -> [OrdersResponse] {
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
                return try JSONDecoder().decode([OrdersResponse].self, from: data)
            } catch {
                throw APIError.decoding(error)
            }
        case 401:
            throw APIError.unauthorized
        default:
            throw APIError.server(status: http.statusCode)
        }
    }
}
