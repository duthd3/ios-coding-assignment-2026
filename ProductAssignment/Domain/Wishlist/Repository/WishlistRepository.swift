//
//  WishlistRepository.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

protocol WishlistRepository: Sendable {
    // 초기 찜 목록 로드
    func loadFavoriteProductIDs() -> Set<Int>
    func isFavorite(productID: Int) -> Bool
    func toggle(productID: Int)
}
