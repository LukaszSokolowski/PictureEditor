//
//  GradientButton.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 06/12/2023.
//

import SwiftUI

struct GradientButton: ButtonStyle {
    var buttonStrokeGradient: LinearGradient {
        LinearGradient(colors: [.init(uiColor: .lightOrange),.init(uiColor: .lightRed)],
                                      startPoint: .topLeading,
                                      endPoint: .bottomTrailing)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: Padding.small.rawValue, leading: Padding.small.rawValue, bottom: Padding.small.rawValue, trailing: Padding.small.rawValue))
            .background {
                Capsule()
                    .fill(buttonStrokeGradient)
                    .saturation(1.8)
            }
            .foregroundColor(Color.black)
    }
}
