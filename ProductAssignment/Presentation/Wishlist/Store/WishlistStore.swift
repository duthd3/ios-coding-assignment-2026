//
//  WishlistStore.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

import Observation

@Observable
@MainActor
// 뷰에서 사용할 찜 저장소
final class WishlistStore {
    private let repository: WishlistRepository

    private(set) var favoriteProductIDs: Set<Int>

    init(repository: WishlistRepository) {
        self.repository = repository
        self.favoriteProductIDs = repository.loadFavoriteProductIDs()
    }

    func isFavorite(productID: Int) -> Bool {
        favoriteProductIDs.contains(productID)
    }

    func toggle(productID: Int) {
        repository.toggle(productID: productID)
        favoriteProductIDs = repository.loadFavoriteProductIDs()
    }
}
