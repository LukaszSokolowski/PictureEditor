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
            .padding(Padding.small.rawValue)
            .background(
                Capsule().fill(Color(uiColor: .softBlue))
            )
            .overlay(
                Capsule()
                    .strokeBorder(.black, lineWidth: 1)
            )
    }
}
