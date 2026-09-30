//
//  APIClient.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

import Foundation
import OSLog

enum APIClientError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
}

struct APIClient: Sendable {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.ysome.ProductAssignment",
        category: "Network"
    )

    private let baseURL: String
    private let session: URLSession

    init(
        baseURL: String = "https://dummyjson.com",
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }

    func request<T: Decodable & Sendable>(
        _ endpoint: some Endpoint
    ) async throws -> T {
        guard var components = URLComponents(string: baseURL) else {
            throw APIClientError.invalidURL
        }
        components.path = endpoint.path

        guard let url = components.url else {
            throw APIClientError.invalidURL
        }

        var request = URLRequest(url: url)
        // 현재 요구사항 수준에서는 httpMethod 고정
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        #if DEBUG
        Self.logger.debug("✅ Request: \(request.httpMethod ?? "GET", privacy: .public) \(url.absoluteString, privacy: .public)")
        #endif

        let (data, response) = try await session.data(for: request)

        #if DEBUG
        let responseBody = String(data: data, encoding: .utf8) ?? "UTF-8로 변환할 수 없는 응답입니다."
        Self.logger.debug("✅ Response body: \(responseBody, privacy: .public)")
        #endif

        guard let response = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }
        guard (200..<300).contains(response.statusCode) else {
            throw APIClientError.httpStatus(response.statusCode)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
