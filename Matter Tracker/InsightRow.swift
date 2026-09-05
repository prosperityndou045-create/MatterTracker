//
//  InsightRow.swift
//  matter hackathon
//
//  Created by Tana on 5/9/2026.
//

import SwiftUI
struct InsightRow: View {

    let title: String
    let value: String
    let icon: String

    var body: some View {

        HStack(spacing: 14) {

            Image(systemName: icon)
                .font(.title3)

            VStack(alignment: .leading, spacing: 3) {

                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.headline)
            }

            Spacer()
        }
        .padding()
        .background(.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

