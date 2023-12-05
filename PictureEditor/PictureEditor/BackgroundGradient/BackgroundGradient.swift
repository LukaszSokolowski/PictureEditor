//
//  BackgroundGradient.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 05/12/2023.
//

import SwiftUI

struct BackgroundGradient: View {
    private let animationDuration = 16.0
    
    @State private var animate: Bool = false
    
    var body: some View {
        LinearGradient(colors: [.white, .init(uiColor: .superLightBlue)],
                       startPoint: animate ? .topLeading : .bottomLeading,
                       endPoint: animate ? .bottomTrailing : .topTrailing)
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}
