//
//  ProductDetailView.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

import SwiftUI

struct ProductDetailView: View {
    @State private var viewModel: ProductDetailViewModel

    init(productID: Int, appContainer: AppContainer) {
        _viewModel = State(
            initialValue: ProductDetailViewModel(
                productID: productID,
                productRepository: appContainer.productRepository,
                wishlistStore: appContainer.wishlistStore
            )
        )
    }

    var body: some View {
        Group {
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
                            await viewModel.loadProduct()
                        }
                    }
                }
            } else if let product = viewModel.product {
                productContent(product)
            } else {
                EmptyView()
            }
        }
        .navigationTitle("상품 상세")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(action: viewModel.toggleFavorite) {
                Image(systemName: viewModel.isFavorite() ? "heart.fill" : "heart")
                    .foregroundStyle(viewModel.isFavorite() ? .red : .primary)
            }
            .accessibilityLabel(viewModel.isFavorite() ? "찜 해제" : "찜 추가")
        }
        .task {
            await viewModel.loadProduct()
        }
    }

    private func productContent(_ product: Product) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                productImage(product)

                VStack(alignment: .leading, spacing: 12) {
                    if let brand = product.brand {
                        Text(brand)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Text(product.name)
                        .font(.title2.bold())

                    Text(product.price, format: .currency(code: "USD"))
                        .font(.title3.weight(.semibold))

                    Label {
                        Text(product.rating, format: .number.precision(.fractionLength(1)))
                    } icon: {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                    .font(.subheadline.weight(.medium))

                    Text(product.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
    }

    @ViewBuilder
    private func productImage(_ product: Product) -> some View {
        AsyncImage(url: product.imageURLs.first ?? product.thumbnailURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            @unknown default:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 280)
        .background(Color.secondary.opacity(0.1))
        .clipShape(.rect(cornerRadius: 16))
    }
}
