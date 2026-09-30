//
//  ProductRowView.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

import SwiftUI

struct ProductRowView: View {
    let product: Product
    let isFavorite: Bool
    let onFavoriteTapped: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            NavigationLink(value: product.id) {
                HStack(spacing: 12) {
                    productImage

                    VStack(alignment: .leading, spacing: 6) {
                        Text(product.name)
                            .font(.headline)
                            .lineLimit(2)

                        Text(product.price, format: .currency(code: "USD"))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Button(action: onFavoriteTapped) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(isFavorite ? .red : .secondary)
            }
            .buttonStyle(.borderless)
            .accessibilityLabel(isFavorite ? "찜 해제" : "찜 추가")
        }
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private var productImage: some View {
        AsyncImage(url: product.thumbnailURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 80, height: 80)
        .background(Color.secondary.opacity(0.1))
        .clipShape(.rect(cornerRadius: 12))
    }
}
