//
//  ReportStatCard.swift
//  matter hackathon
//
//  Created by Tana on 5/9/2026.
//
import SwiftUI

struct ReportStatCard: View {

    let title: String
    let value: String
    let icon: String

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {

            Image(systemName: icon)
                .font(.title2)

            Text(value)
                .font(.title)
                .fontWeight(.bold)

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.gray.opacity(0.08))
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }
}
