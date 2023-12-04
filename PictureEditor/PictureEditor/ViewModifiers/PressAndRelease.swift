//
//  PressAndRelease.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 04/12/2023.
//

import SwiftUI

struct PressAndRelease: ViewModifier {
    @Binding var pressing: Bool
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content.simultaneousGesture(
            DragGesture(minimumDistance: .zero)
                .onChanged{ state in
                    pressing = true
                }
                .onEnded{ _ in
                    pressing = false
                    onRelease()
                }
        )
    }
}

extension View {
    func pressAndReleaseAction(pressing: Binding<Bool>, onRelease: @escaping (() -> Void)) -> some View {
        modifier(PressAndRelease(pressing: pressing, onRelease: onRelease))
    }
}
