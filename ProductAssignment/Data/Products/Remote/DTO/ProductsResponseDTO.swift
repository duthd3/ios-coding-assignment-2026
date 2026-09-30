//
//  ProductsResponseDTO.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

struct ProductsResponseDTO: Decodable, Sendable {
    let products: [ProductDTO]
    let total: Int
    let skip: Int
    let limit: Int
}
