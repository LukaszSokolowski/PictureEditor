//
//  ImageFilters.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 09/12/2023.
//

import UIKit

enum BlurType: String, CaseIterable {
    case zoom = "CIZoomBlur"
    case gaussian = "CIGaussianBlur"
    case disk = "CIDiscBlur"
    case box = "CIBoxBlur"
    case maskedVariable = "CIMaskedVariableBlur"
    
    var name: String {
        switch self {
        case .zoom:
            return "Zoom"
        case .gaussian:
            return "Gaussian"
        case .disk:
            return "Disk"
        case .box:
            return "Box"
        case .maskedVariable:
            return "Masked"
        }
    }
}

final class ImageFilters {
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    func applyBlurFilter(val: CGFloat, filterType: BlurType) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return .init() }
        let blurFilter = CIFilter(name: filterType.rawValue)
        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(val, forKey: kCIInputRadiusKey)
        
        let rect = ciImage.extent
        let context = CIContext(options: nil)
        if let output = blurFilter?.outputImage,
           let cgimg = context.createCGImage(output, from: rect) {
            return UIImage(cgImage: cgimg)
        }
        fatalError()
    }
}
