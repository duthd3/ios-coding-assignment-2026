//
//  Product.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

import Foundation

// 상품 domain 모델
struct Product: Identifiable, Equatable, Sendable {
    let id: Int
    let name: String
    let description: String
    let brand: String?
    let price: Decimal
    let rating: Double
    let thumbnailURL: URL?
    let imageURLs: [URL]
}
