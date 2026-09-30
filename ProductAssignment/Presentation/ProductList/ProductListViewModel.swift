//
//  ProductListViewModel.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class ProductListViewModel {
    private let productRepository: any ProductRepository
    private let wishlistStore: WishlistStore

    private(set) var products: [Product] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var layout: ProductListLayout = .list
    // 원격 상품 조회와 전역 찜 상태를 외부에서 주입받아 테스트와 화면 간 상태 공유를 지원
    init(
        productRepository: any ProductRepository,
        wishlistStore: WishlistStore
    ) {
        self.productRepository = productRepository
        self.wishlistStore = wishlistStore
    }

    func loadProducts() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            products = try await productRepository.fetchProducts()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggleLayout() {
        layout.toggle()
    }

    func isFavorite(productID: Int) -> Bool {
        wishlistStore.isFavorite(productID: productID)
    }

    func toggleFavorite(productID: Int) {
        wishlistStore.toggle(productID: productID)
    }
}
