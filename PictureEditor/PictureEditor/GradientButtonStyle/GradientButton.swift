//
//  GradientButton.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 06/12/2023.
//

import SwiftUI

struct GradientButton: ButtonStyle {
    private let cornerRadius = 8.0
    
    var buttonStrokeGradient: LinearGradient {
        LinearGradient(colors: [.init(uiColor: .superLightBlue), .init(uiColor: .lightBlue)],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, Padding.small.rawValue)
            .padding(.horizontal, Padding.normal.rawValue)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(buttonStrokeGradient))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(Color(uiColor: .softBlue), lineWidth: 1)
            )
    }
}
