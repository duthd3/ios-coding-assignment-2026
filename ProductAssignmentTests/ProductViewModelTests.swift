//
//  ProductViewModelTests.swift
//  ProductAssignmentTests
//
//  Created by yeosong on 9/30/26.
//

import Foundation
import Testing

@testable import ProductAssignment

@Suite("ProductListViewModel 테스트")
@MainActor
struct ProductListViewModelTests {
    @Test("상품 조회에 성공하면 목록 상태를 갱신한다")
    func loadProductsUpdatesProducts() async throws {
        let product = makeProduct(id: 1)
        let repository = ProductRepositorySpy(products: [product])
        let sut = try makeSUT(productRepository: repository)
        defer { clearUserDefaults(sut.userDefaults, suiteName: sut.suiteName) }

        await sut.viewModel.loadProducts()

        #expect(sut.viewModel.products == [product])
        #expect(!sut.viewModel.isLoading)
        #expect(sut.viewModel.errorMessage == nil)
    }

    @Test("상품 조회에 실패하면 오류 상태를 갱신한다")
    func loadProductsSetsErrorMessage() async throws {
        let repository = ProductRepositorySpy(shouldFail: true)
        let sut = try makeSUT(productRepository: repository)
        defer { clearUserDefaults(sut.userDefaults, suiteName: sut.suiteName) }

        await sut.viewModel.loadProducts()

        #expect(sut.viewModel.products.isEmpty)
        #expect(sut.viewModel.errorMessage != nil)
        #expect(!sut.viewModel.isLoading)
    }

    @Test("찜 토글은 공유된 찜 상태를 변경한다")
    func toggleFavoriteChangesWishlistState() throws {
        let sut = try makeSUT(productRepository: ProductRepositorySpy())
        defer { clearUserDefaults(sut.userDefaults, suiteName: sut.suiteName) }

        sut.viewModel.toggleFavorite(productID: 1)

        #expect(sut.viewModel.isFavorite(productID: 1))
    }

    private func makeSUT(
        productRepository: some ProductRepository
    ) throws -> (
        viewModel: ProductListViewModel,
        userDefaults: UserDefaults,
        suiteName: String
    ) {
        let suiteName = "ProductListViewModelTests.\(UUID().uuidString)"
        let userDefaults = try #require(UserDefaults(suiteName: suiteName))
        let wishlistRepository = UserDefaultsWishlistRepository(userDefaults: userDefaults)
        let wishlistStore = WishlistStore(repository: wishlistRepository)

        return (
            ProductListViewModel(
                productRepository: productRepository,
                wishlistStore: wishlistStore
            ),
            userDefaults,
            suiteName
        )
    }
}

@Suite("ProductDetailViewModel 테스트")
@MainActor
struct ProductDetailViewModelTests {
    @Test("상세 진입 시 전달받은 상품 ID로 조회한다")
    func loadProductRequestsProductID() async throws {
        let product = makeProduct(id: 1)
        let repository = ProductRepositorySpy(product: product)
        let sut = try makeSUT(productID: product.id, productRepository: repository)
        defer { clearUserDefaults(sut.userDefaults, suiteName: sut.suiteName) }

        await sut.viewModel.loadProduct()

        #expect(sut.viewModel.product == product)
        #expect(await repository.requestedProductIDs() == [product.id])
    }

    @Test("상세 화면의 찜 토글은 찜 상태를 변경한다")
    func toggleFavoriteChangesWishlistState() throws {
        let sut = try makeSUT(productID: 1, productRepository: ProductRepositorySpy())
        defer { clearUserDefaults(sut.userDefaults, suiteName: sut.suiteName) }

        sut.viewModel.toggleFavorite()

        #expect(sut.viewModel.isFavorite())
    }

    private func makeSUT(
        productID: Int,
        productRepository: some ProductRepository
    ) throws -> (
        viewModel: ProductDetailViewModel,
        userDefaults: UserDefaults,
        suiteName: String
    ) {
        let suiteName = "ProductDetailViewModelTests.\(UUID().uuidString)"
        let userDefaults = try #require(UserDefaults(suiteName: suiteName))
        let wishlistRepository = UserDefaultsWishlistRepository(userDefaults: userDefaults)
        let wishlistStore = WishlistStore(repository: wishlistRepository)

        return (
            ProductDetailViewModel(
                productID: productID,
                productRepository: productRepository,
                wishlistStore: wishlistStore
            ),
            userDefaults,
            suiteName
        )
    }
}

private actor ProductRepositorySpy: ProductRepository {
    private let products: [Product]
    private let product: Product?
    private let shouldFail: Bool
    private var productIDs: [Int] = []

    init(
        products: [Product] = [],
        product: Product? = nil,
        shouldFail: Bool = false
    ) {
        self.products = products
        self.product = product
        self.shouldFail = shouldFail
    }

    func fetchProducts() async throws -> [Product] {
        if shouldFail {
            throw ProductRepositorySpyError.failed
        }

        return products
    }

    func fetchProduct(id: Int) async throws -> Product {
        productIDs.append(id)

        if shouldFail {
            throw ProductRepositorySpyError.failed
        }

        guard let product else {
            throw ProductRepositorySpyError.productNotFound
        }

        return product
    }

    func requestedProductIDs() -> [Int] {
        productIDs
    }
}

private enum ProductRepositorySpyError: Error {
    case failed
    case productNotFound
}

private func makeProduct(id: Int) -> Product {
    Product(
        id: id,
        name: "상품 \(id)",
        description: "상품 설명",
        brand: "테스트 브랜드",
        price: 10,
        rating: 4.5,
        thumbnailURL: nil,
        imageURLs: []
    )
}

private func clearUserDefaults(_ userDefaults: UserDefaults, suiteName: String) {
    userDefaults.removePersistentDomain(forName: suiteName)
}
