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
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
        }
        .background(Color(uiColor: .buttonBackground))
        .foregroundColor(.white)
        .clipShape(Capsule())
    }
}
