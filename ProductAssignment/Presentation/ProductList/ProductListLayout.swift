//
//  ProductListLayout.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//
// 뷰 레이아웃 케이스
enum ProductListLayout: Sendable {
    case list
    case grid

    mutating func toggle() {
        switch self {
        case .list:
            self = .grid
        case .grid:
            self = .list
        }
    }
}
