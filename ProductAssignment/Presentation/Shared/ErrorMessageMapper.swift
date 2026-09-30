//
//  ErrorMessageMapper.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

import Foundation

enum ErrorMessageMapper {
    static func message(for error: Error) -> String {
        guard let error = error as? APIClientError else {
            return "알 수 없는 오류가 발생했습니다. 다시 시도해 주세요."
        }

        switch error {
        case .network(.notConnectedToInternet), .network(.networkConnectionLost):
            return "인터넷 연결을 확인해 주세요."
        case .network(.timedOut):
            return "응답 시간이 초과되었습니다. 다시 시도해 주세요."

        case .network:
            return "네트워크 오류가 발생했습니다. 다시 시도해 주세요."

        case .httpStatus:
            return "상품 정보를 불러올 수 없습니다."

        case .decoding:
            return "상품 정보를 처리하지 못했습니다. 다시 시도해 주세요."

        case .invalidURL,
             .invalidResponse,
             .unknown:
            return "상품 정보를 불러올 수 없습니다. 다시 시도해 주세요."
        }
    }
}
