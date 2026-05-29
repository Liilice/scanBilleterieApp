//
//  Orders.swift
//  billeterieScan
//
//  Created by Alice Zheng on 27/05/2026.
//
import Foundation

struct OrdersResponse: Decodable, Identifiable {
    let id: String
    let concertDate: String
    let concertTime: String
    let concertTitle: String
    let createdAt: String
    let email: String
    let name: String
    let quantitiesBuy: Int
    let quantities: Int
}

struct GroupedTicketUsage: Decodable {
    let concertDate: String
    let tickets: [OrdersResponse]
};

struct OrderUpdateResponse: Decodable {
    let success: Bool
}

struct OrderUpdateRequest: Encodable {
    let id: String
    let quantities: Int
}
