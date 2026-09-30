//
//  Endpoint.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

protocol Endpoint: Sendable {
    /// 요구사항 기준으로는 GET이외의 메서드가 없고, 조회 이외에 task가 없으므로 기본 path 하나만 선언
    var path: String { get }

}
