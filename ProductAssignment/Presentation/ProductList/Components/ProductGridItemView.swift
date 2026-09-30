//
//  ProductGridItemView.swift
//  ProductAssignment
//
//  Created by yeosong on 9/30/26.
//

import SwiftUI

struct ProductGridItemView: View {
    let product: Product
    let isFavorite: Bool
    let onFavoriteTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                NavigationLink(value: product.id) {
                    productImage
                }
                .buttonStyle(.plain)

                Button(action: onFavoriteTapped) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(isFavorite ? .red : .secondary)
                        .padding(8)
                        .background(.thinMaterial, in: Circle())
                }
                .buttonStyle(.borderless)
                .padding(8)
                .accessibilityLabel(isFavorite ? "찜 해제" : "찜 추가")
            }

            NavigationLink(value: product.id) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(2)

                    Text(product.price, format: .currency(code: "USD"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)
        }
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
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .background(Color.secondary.opacity(0.1))
        .clipShape(.rect(cornerRadius: 12))
    }
}
