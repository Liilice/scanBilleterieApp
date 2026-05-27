//
//  Auth.swift
//  billeterieScan
//

import Foundation

struct LoginRequest: Encodable {
    let password: String
}

struct LoginResponse: Decodable {
    let token: String
}
