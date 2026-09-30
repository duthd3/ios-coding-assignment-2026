//
//  ProductDTO.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

import Foundation

struct ProductDTO: Decodable, Sendable {
    let id: Int
    let title: String
    let description: String
    let price: Decimal
    let thumbnail: String
    let images: [String]
}
