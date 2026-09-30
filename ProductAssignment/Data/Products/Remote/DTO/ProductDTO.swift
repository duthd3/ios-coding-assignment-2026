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
    let brand: String?
    let price: Decimal
    let rating: Double
    let thumbnail: String
    let images: [String]

    // 현재 요구사항에서는 Mapper를 따로 두는것 보다 DTO에서 직접 변환해주면 충분
    func toEntity() -> Product {
        Product(
            id: id,
            name: title,
            description: description,
            brand: brand,
            price: price,
            rating: rating,
            thumbnailURL: URL(string: thumbnail),
            imageURLs: images.compactMap { URL(string: $0) }
        )
    }
}
