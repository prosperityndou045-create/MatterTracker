//
//  VerificationBadge.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct VerificationBadge: View {
    var body: some View{
        VStack(spacing: 4) {
            Image(
                systemName: "checkmark.seal.fill"
            )
            .font(.title)
            
            Text("Verified")
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(10)
        .background(Color.secondary.opacity(0.88)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 10
            )
        )
    }
}
