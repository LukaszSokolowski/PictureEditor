//
//  PopupView.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 06/12/2023.
//

import SwiftUI

struct PopupView: View {
    private let blurEffectRadius = 4.0
    private let title: String
    private let content: String?
    private let buttonTitle: String?
    private let buttonAction: (() -> ())?
    
    init(title: String, content: String?, buttonTitle: String?, buttonAction: (() -> ())?) {
        self.title = title
        self.content = content
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                VStack {
                    Text(title)
                    if let content { Text(content) }
                    if let buttonTitle, let buttonAction {
                        Button {
                            buttonAction()
                        } label: {
                            Text(buttonTitle)
                        }
                    }
                }
                Spacer()
            }
            Spacer()
        }.background(BlurEffect().blur(radius: blurEffectRadius))
    }
}

#Preview {
    let action: () -> () = {
        let _ = print("Action performed")
    }
    return PopupView(title: "Test title",
                     content: "Test content",
                     buttonTitle: "Click me!",
                     buttonAction: action)
}
