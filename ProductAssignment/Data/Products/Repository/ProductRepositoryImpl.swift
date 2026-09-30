//
//  ProductRepositoryImpl.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

final class ProductRepositoryImpl: ProductRepository {
    private let apiClient: APIClient

    // 기본 APIClient를 사용하되, 테스트나 서버 설정 변경 시 다른 인스턴스를 주입할 수 있도록 구성
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchProducts() async throws -> [Product] {
        let response: ProductsResponseDTO = try await apiClient.request(ProductEndpoint.list)

        return response.products.map { $0.toEntity() }
    }

    func fetchProduct(id: Int) async throws -> Product {
        let response: ProductDTO = try await apiClient.request(ProductEndpoint.detail(id: id))

        return response.toEntity()
    }
}
