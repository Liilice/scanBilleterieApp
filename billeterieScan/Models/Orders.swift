//
//  Orders.swift
//  billeterieScan
//
//  Created by Alice Zheng on 27/05/2026.
//
import Foundation

struct OrdersResponse: Decodable {
    let id: String
    let concertDate: String
    let concertTime: String
    let concertTitle: String
    let createdAt: String
    let email: String
    let name: String
    let quantitiesBuy: Float
    let quantities: Int
}
