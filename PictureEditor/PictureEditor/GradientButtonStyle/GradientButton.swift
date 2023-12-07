//
//  GradientButton.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 06/12/2023.
//

import SwiftUI

struct GradientButton: ButtonStyle {
    var buttonStrokeGradient: LinearGradient {
        LinearGradient(colors: [.init(uiColor: .lightBlue),.init(uiColor: .softBlue)],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, Padding.small.rawValue)
            .padding(.horizontal, Padding.normal.rawValue)
            .background(
                RoundedRectangle(cornerRadius: 8).fill(Color(uiColor: .softBlue))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8).strokeBorder(.black, lineWidth: 1)
            )
    }
}
