//
//  PopupView.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 06/12/2023.
//

import SwiftUI

struct PopupView: View {
    private let blurEffectRadius = 4.0
    private let clipShapeRadius = 12.0
    private let shadowRadius = 8.0
    private let title: String
    private let content: String?
    private let confirmButtonTitle: String?
    private let confirmAction: (() -> ())?
    private let cancelButtonTitle: String?
    private let cancelAction: (() -> ())?
    
    init(title: String,
         content: String?,
         confirmButtonTitle: String?,
         cancelButtonTitle: String?,
         confirmAction: (() -> ())?,
         cancelAction: (() -> ())?) {
        self.title = title
        self.content = content
        self.confirmButtonTitle = confirmButtonTitle
        self.cancelButtonTitle = cancelButtonTitle
        self.confirmAction = confirmAction
        self.cancelAction = cancelAction
    }
    
    var gradient: some View {
        LinearGradient(colors: [.white, .init(uiColor: .lightBlue)],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }
    
    var body: some View {
        ZStack{
            VStack {}.frame(maxWidth: .infinity, maxHeight: .infinity).background(.black).opacity(0.5)
            VStack {
                VStack(spacing: Padding.normal.rawValue) {
                    Text(title)
                        .fontWeight(.bold)
                        .font(.title)
                    if let content {
                        Text(content)
                            .font(.headline)
                            .fontWeight(.light)
                    }
                    VStack(spacing: Padding.small.rawValue) {
                        if let confirmButtonTitle, let confirmAction {
                            Button(confirmButtonTitle) {
                                confirmAction()
                            }.buttonStyle(GradientButton())
                        }
                        if let cancelButtonTitle, let cancelAction {
                            Button(cancelButtonTitle) {
                                cancelAction()
                            }.buttonStyle(GradientButton())
                        }
                    }
                }
                .padding(Padding.big.rawValue)
                .background(gradient)
                .clipShape(RoundedRectangle(cornerRadius: clipShapeRadius, style: .continuous))
                .shadow(radius: shadowRadius)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlurEffect().blur(radius: blurEffectRadius))
    }
}

#Preview {
    let confirmAction: () -> () = {
        let _ = print("Action performed")
    }
    let cancelAction: () -> () = {
        let _ = print("Cancel action performed")
    }
    return PopupView(title: "Test title",
                     content: "Test content",
                     confirmButtonTitle: "Click me!",
                     cancelButtonTitle: "Cancel",
                     confirmAction: confirmAction,
                     cancelAction: cancelAction)
}
