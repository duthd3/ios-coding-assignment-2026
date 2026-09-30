//
//  UserDefaultsWishlistRepository.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

import Foundation

final class UserDefaultsWishlistRepository: WishlistRepository {
    private enum StorageKey {
        static let favoriteProductIDs = "favorite_product_ids"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func loadFavoriteProductIDs() -> Set<Int> {
        let productIDs = userDefaults.array(
            forKey: StorageKey.favoriteProductIDs
        ) as? [Int] ?? []

        return Set(productIDs)
    }

    func isFavorite(productID: Int) -> Bool {
        loadFavoriteProductIDs().contains(productID)
    }

    func toggle(productID: Int) {
        var productIDs = loadFavoriteProductIDs()

        if productIDs.contains(productID) {
            productIDs.remove(productID)
        } else {
            productIDs.insert(productID)
        }

        userDefaults.set(
            // 저장 순서를 고려해 디버깅과 테스트 결과 예측 가능하게 유지
            productIDs.sorted(),
            forKey: StorageKey.favoriteProductIDs
        )
    }
}
