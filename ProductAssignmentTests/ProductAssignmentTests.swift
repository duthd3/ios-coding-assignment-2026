//
//  ProductAssignmentTests.swift
//  ProductAssignmentTests
//
//  Created by yeosong on 9/30/26.
//

import Foundation
import Testing

@testable import ProductAssignment

@Suite("UserDefaultsWishlistRepository 테스트")
struct UserDefaultsWishlistRepositoryTests {
    @Test("초기 찜 상품 목록은 비어 있다")
    @MainActor
    func initialFavoriteProductIDsAreEmpty() throws {
        let sut = try makeSUT()
        defer { clearUserDefaults(sut.userDefaults, suiteName: sut.suiteName) }

        #expect(sut.repository.loadFavoriteProductIDs().isEmpty)
    }

    @Test("찜하지 않은 상품을 토글하면 찜 목록에 추가된다")
    @MainActor
    func toggleAddsProductToFavorites() throws {
        let sut = try makeSUT()
        defer { clearUserDefaults(sut.userDefaults, suiteName: sut.suiteName) }

        sut.repository.toggle(productID: 1)

        #expect(sut.repository.isFavorite(productID: 1))
        #expect(sut.repository.loadFavoriteProductIDs() == Set([1]))
    }

    @Test("이미 찜한 상품을 다시 토글하면 찜 목록에서 제거된다")
    @MainActor
    func toggleRemovesProductFromFavorites() throws {
        let sut = try makeSUT()
        defer { clearUserDefaults(sut.userDefaults, suiteName: sut.suiteName) }

        sut.repository.toggle(productID: 1)
        sut.repository.toggle(productID: 1)

        #expect(!sut.repository.isFavorite(productID: 1))
        #expect(sut.repository.loadFavoriteProductIDs().isEmpty)
    }

    @Test("새 Repository를 생성해도 저장된 찜 상태를 복원한다")
    @MainActor
    func favoritesPersistAcrossRepositoryInstances() throws {
        let sut = try makeSUT()
        defer { clearUserDefaults(sut.userDefaults, suiteName: sut.suiteName) }

        sut.repository.toggle(productID: 1)

        let restoredRepository = UserDefaultsWishlistRepository(
            userDefaults: sut.userDefaults
        )

        #expect(restoredRepository.isFavorite(productID: 1))
    }

    @MainActor
    private func makeSUT() throws -> (
        repository: UserDefaultsWishlistRepository,
        userDefaults: UserDefaults,
        suiteName: String
    ) {
        let suiteName = "UserDefaultsWishlistRepositoryTests.\(UUID().uuidString)"
        let userDefaults = try #require(UserDefaults(suiteName: suiteName))

        clearUserDefaults(userDefaults, suiteName: suiteName)

        return (
            UserDefaultsWishlistRepository(userDefaults: userDefaults),
            userDefaults,
            suiteName
        )
    }

    @MainActor
    private func clearUserDefaults(
        _ userDefaults: UserDefaults,
        suiteName: String
    ) {
        userDefaults.removePersistentDomain(forName: suiteName)
    }
}
