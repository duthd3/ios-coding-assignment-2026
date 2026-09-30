//
//  ProductRepository.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

protocol ProductRepository: Sendable {
    // 상품 조회
    func fetchProducts() async throws -> [Product]
    // 상품 상세 조회
    func fetchProduct(id: Int) async throws -> Product
}
