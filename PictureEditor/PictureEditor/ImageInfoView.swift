//
//  ImageInfoView.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 15/10/2022.
//

import SwiftUI
import ImageIO

struct ImageInfoView: View {
    let processedImage: UIImage
    
    init(processedImage: UIImage) {
        self.processedImage = processedImage
    }
    
    var imageWidth: String {
        guard let width = processedImage.cgImage?.width as? NSNumber else { return "" }
        return NumberFormatter().string(from: width) ?? ""
    }
    
    var imageHeight: String {
        guard let height = processedImage.cgImage?.height as? NSNumber else { return ""}
        return NumberFormatter().string(from: height) ?? ""
    }
    
    var colorSpace: String {
        guard let colorSpace = processedImage.cgImage?.colorSpace else { return "Unknown" }
        if colorSpace == CGColorSpace(name: CGColorSpace.sRGB) { return "sRGB" }
        if colorSpace == CGColorSpace(name: CGColorSpace.displayP3) { return "DisplayP3" }
        return "Unknown"
    }
    
    var alphaChannel: String {
        return "TODO"
    }
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            VStack {
                Text("Image width: " + imageWidth)
                Text("Image height: " + imageHeight)
                Text("Image color space: " + colorSpace)
                Text("Alpha channel: " + alphaChannel)
                PageView(pages: [PageOption(processedImage: processedImage),
                                 PageOption(processedImage: processedImage),
                                 PageOption(processedImage: processedImage)])
            }
        }
    }
}

struct ImageInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ImageInfoView(processedImage: .init())
    }
}

extension UIImage {
    var typeIdentifier: String? {
        cgImage?.utType as String?
    }
}
