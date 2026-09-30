//
//  AppContainer.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

@MainActor
// 앱 의존성 조립 컨테이너
final class AppContainer {
    let productRepository: any ProductRepository
    let wishlistStore: WishlistStore

    init() {
        let wishlistRepository = UserDefaultsWishlistRepository()

        self.productRepository = ProductRepositoryImpl()
        self.wishlistStore = WishlistStore(repository: wishlistRepository)
    }

    init(
        productRepository: any ProductRepository,
        wishlistRepository: any WishlistRepository
    ) {
        self.productRepository = productRepository
        self.wishlistStore = WishlistStore(repository: wishlistRepository)
    }
}
