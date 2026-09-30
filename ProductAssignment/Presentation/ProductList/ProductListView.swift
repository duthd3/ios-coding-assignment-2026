//
//  ProductListView.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

import SwiftUI

struct ProductListView: View {
    private let appContainer: AppContainer
    @State private var viewModel: ProductListViewModel

    init(appContainer: AppContainer) {
        self.appContainer = appContainer
        _viewModel = State(
            initialValue: ProductListViewModel(
                productRepository: appContainer.productRepository,
                wishlistStore: appContainer.wishlistStore
            )
        )
    }

    var body: some View {
        // 기본 네비게이션 스택 사용
        NavigationStack {
            content
                .navigationTitle("상품")
                .navigationDestination(for: Int.self) { productID in
                    ProductDetailView(productID: productID, appContainer: appContainer)
                }
                .toolbar {
                    Button(action: viewModel.toggleLayout) {
                        Image(systemName: layoutButtonImageName)
                    }
                    .accessibilityLabel(layoutButtonAccessibilityLabel)
                }
        }
        .task {
            await viewModel.loadProducts()
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView {
                Label("상품을 불러올 수 없습니다", systemImage: "exclamationmark.triangle")
            } description: {
                Text(errorMessage)
            } actions: {
                Button("다시 시도") {
                    Task {
                        await viewModel.loadProducts()
                    }
                }
            }
        } else if viewModel.products.isEmpty {
            ContentUnavailableView(
                "표시할 상품이 없습니다",
                systemImage: "shippingbox"
            )
        } else {
            productContent
        }
    }

    @ViewBuilder
    private var productContent: some View {
        switch viewModel.layout {
        case .list:
            List(viewModel.products) { product in
                ProductRowView(
                    product: product,
                    isFavorite: viewModel.isFavorite(productID: product.id),
                    onFavoriteTapped: {
                        viewModel.toggleFavorite(productID: product.id)
                    }
                )
            }
            .listStyle(.plain)

        case .grid:
            ScrollView {
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible(), spacing: 16),
                        count: 2
                    ),
                    spacing: 16
                ) {
                    ForEach(viewModel.products) { product in
                        ProductGridItemView(
                            product: product,
                            isFavorite: viewModel.isFavorite(productID: product.id),
                            onFavoriteTapped: {
                                viewModel.toggleFavorite(productID: product.id)
                            }
                        )
                    }
                }
                .padding()
            }
        }
    }

    private var layoutButtonImageName: String {
        switch viewModel.layout {
        case .list:
            "square.grid.2x2"
        case .grid:
            "list.bullet"
        }
    }

    private var layoutButtonAccessibilityLabel: String {
        switch viewModel.layout {
        case .list:
            "2열 그리드로 보기"
        case .grid:
            "1열 목록으로 보기"
        }
    }
}
