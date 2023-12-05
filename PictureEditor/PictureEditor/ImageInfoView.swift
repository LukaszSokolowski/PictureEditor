//
//  ImageInfoView.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 15/10/2022.
//

import SwiftUI

struct ImageInfoView: View {
    let passedImage: UIImage
    
    init(passedImage: UIImage) {
        self.passedImage = passedImage
    }
    
    var imageWidth: String {
        NumberFormatter().string(from: passedImage.size.width as NSNumber) ?? ""
    }
    
    var imageHeight: String {
        NumberFormatter().string(from: passedImage.size.height as NSNumber) ?? ""
    }
    
    var colorSpace: String {
        String(describing: passedImage.cgImage?.colorSpace?.name)
    }
    
    var body: some View {
        HStack {
            VStack {
                Text("Image width: " + imageWidth)
                Text("Image height: " + imageHeight)
                Text("Image color space: " + colorSpace)
                Spacer()
            }
            Spacer()
        }.background(BackgroundGradient())
    }
}

struct ImageInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ImageInfoView(passedImage: .init())
    }
}
