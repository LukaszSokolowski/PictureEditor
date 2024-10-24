//
//  SwiftUIView.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 03/12/2023.
//

import SwiftUI
import TipKit

struct OriginalImageTip: Tip {
    var id: String = UUID().uuidString
    
    @available(iOS 17.0, *)
    @Parameter static var orignalImageChanged: Bool = false
    
    @available(iOS 17.0, *)
    var rules: [Rule] {
        [
            #Rule(Self.$orignalImageChanged) {
                $0 == true
            }
        ]
    }
    
    var title: Text {
        Text("Tap and hold to view the original photo")
    }
    
    var image: Image? {
        Image(systemName: Icons.handTap)
    }
}
