//
//  ProductDTO.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

import Foundation

nonisolated struct ProductDTO: Decodable, Sendable {
    let id: Int
    let title: String
    let description: String
    let price: Decimal
    let thumbnail: String
    let images: [String]

    func toEntity() -> Product {
        Product(
            id: id,
            name: title,
            description: description,
            price: price,
            thumbnailURL: URL(string: thumbnail),
            imageURLs: images.compactMap { URL(string: $0) }
        )
    }
}
