//
//  APIClient.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

import Foundation

enum APIClientError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
}

struct APIClient: Sendable {
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
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }
        guard (200..<300).contains(response.statusCode) else {
            throw APIClientError.httpStatus(response.statusCode)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
