//
//  ProductDetailViewModel.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class ProductDetailViewModel {
    private let productID: Int
    private let productRepository: any ProductRepository
    private let wishlistStore: WishlistStore

    private(set) var product: Product?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    init(
        productID: Int,
        productRepository: any ProductRepository,
        wishlistStore: WishlistStore
    ) {
        self.productID = productID
        self.productRepository = productRepository
        self.wishlistStore = wishlistStore
    }

    func loadProduct() async {
        guard !isLoading else {
            return
        }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            product = try await productRepository.fetchProduct(id: productID)
        } catch {
            errorMessage = ErrorMessageMapper.message(for: error)
        }
    }

    func isFavorite() -> Bool {
        wishlistStore.isFavorite(productID: productID)
    }

    func toggleFavorite() {
        wishlistStore.toggle(productID: productID)
    }
}
