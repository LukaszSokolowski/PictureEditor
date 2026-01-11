//
//  GradientButton.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 06/12/2023.
//

import SwiftUI

struct PillButton: View {
    let title: String
    let isWide: Bool
    let action: () -> Void
    
    init(
        title: String,
        isWide: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isWide = isWide
        self.action = action
    }
    
    var body: some View {
        if #available(iOS 26.0, *) {
            Button(action: action) {
                Text(title)
                    .fontWeight(.light)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .frame(maxWidth: isWide ? .infinity : nil)
            }
            .buttonStyle(.glass)
        } else {
            Button(action: action) {
                Text(title)
                    .fontWeight(.light)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .frame(maxWidth: isWide ? .infinity : nil)
            }
            .background(Color(uiColor: .buttonBackground))
            .foregroundColor(Color(uiColor: .background))
            .clipShape(Capsule())
        }
        
    }
}
