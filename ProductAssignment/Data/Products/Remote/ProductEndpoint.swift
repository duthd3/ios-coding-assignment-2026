//
//  ProductEndpoint.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

enum ProductEndpoint: Endpoint {
    case list
    case detail(id: Int)

    var path: String {
        switch self {
        case .list:
            "/products"
        case .detail(let id):
            "/products/\(id)"
        }
    }
}
