//
//  ImageInfoView.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 15/10/2022.
//

import SwiftUI
import ImageIO

struct ImageInfoView: View {
    let passedImage: UIImage
    
    init(passedImage: UIImage) {
        self.passedImage = passedImage
    }
    
    var imageWidth: String {
        NumberFormatter().string(from: passedImage.cgImage!.width as NSNumber) ?? ""
    }
    
    var imageHeight: String {
        NumberFormatter().string(from: passedImage.cgImage!.height as NSNumber) ?? ""
    }
    
    var colorSpace: String {
        //TODO: do some switch case here (create w class outside view)
        guard let colorSpace = passedImage.cgImage?.colorSpace else { return "Unknown" }
        if colorSpace == CGColorSpace(name: CGColorSpace.sRGB) { return "sRGB" }
        if colorSpace == CGColorSpace(name: CGColorSpace.displayP3) { return "DisplayP3" }
        return "Unknown"
    }
    
    var alphaChannel: String {
        return "TODO"
    }
    
    var body: some View {
        HStack {
            VStack {
                Text("Image width: " + imageWidth)
                Text("Image height: " + imageHeight)
                Text("Image color space: " + colorSpace)
                Text("Alpha channel: " + alphaChannel)
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

extension UIImage {
    var typeIdentifier: String? {
        cgImage?.utType as String?
    }
}
