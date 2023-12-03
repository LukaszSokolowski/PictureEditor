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
    
    var title: Text {
        Text("Tap and hold to see your orignal photo")
    }
    
    var image: Image? {
        Image(systemName: "hand.tap")
    }
}
