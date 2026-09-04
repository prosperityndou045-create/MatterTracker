//
//  EvidenceRow.swift
//  Matter Tracker
//
//  Created by admin on 9/4/26.
//

import SwiftUI

struct EvidenceRow: View {
    let evidenc: Evidence
    
    var body: some View {
        HStack(spacing: 40){
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 35)
            
            VStack(
                alignment: .leading,
                spacing: 4
            ){
                Text(evidence.title)
                       .fontWeight(.semibold)

                   Text(evidence.type.rawValue)
                       .font(.caption)
                       .foregroundStyle(.secondary)
               }

               Spacer()

               if evidence.status == .verified {

                   Image(
                       systemName: "checkmark.seal.fill"
                   )
               }

               Image(
                   systemName: "chevron.right"
               )
               .font(.caption)
               .foregroundStyle(.secondary)
           }
           .padding()
           .background(
               Color.secondary.opacity(0.08)
           )
           .clipShape(
               RoundedRectangle(
                   cornerRadius: 12
               )
           )
       }

       private var icon: String {

           switch evidence.type {

           case .codeSample:
               return "chevron.left.forwardslash.chevron.right"

           case .challenge:
               return "flag"

           case .github:
               return "folder"

           case .video:
               return "play.rectangle"

           case .project:
               return "hammer"

           case .feedback:
               return "text.bubble"

           case .assessment:
               return "doc.text"
           }
       }
   }
          
