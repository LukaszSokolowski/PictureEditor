//
//  ImageFilters.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 09/12/2023.
//

import UIKit

enum ImageFilterType: String {
    case zoomBlur = "CIZoomBlur"
    case gaussianBlur = "CIGaussianBlur"
}

final class ImageFilters {
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    func applyBlurFilter(val: CGFloat, filterType: ImageFilterType) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return .init() }
        let blurFilter = CIFilter(name: filterType.rawValue)
        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(val, forKey: kCIInputRadiusKey)
        
        let rect = ciImage.extent
        if let output = blurFilter?.outputImage {
            let context = CIContext(options: nil)
            if let cgimg = context.createCGImage(output, from: rect) {
                let processedImage = UIImage(cgImage: cgimg)
                return processedImage
            }
        }
        fatalError()
    }
}
