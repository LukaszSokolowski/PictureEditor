//
//  GradientButton.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 06/12/2023.
//

import SwiftUI

struct PillButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        if #available(iOS 26.0, *) {
            Button(action: action) {
                Text(title)
                    .fontWeight(.light)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.glass)
        } else {
            Button(action: action) {
                Text(title)
                    .fontWeight(.light)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            }
            .background(Color(uiColor: .buttonBackground))
            .foregroundColor(Color(uiColor: .background))
            .clipShape(Capsule())
        }
        
    }
}
