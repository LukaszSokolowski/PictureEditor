//
//  FilterType.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 13/12/2023.
//

import UIKit

enum FilterType: String, CaseIterable {
    case colorClamp = "CIColorClamp"
    
    var name: String {
        switch self {
        case .colorClamp:
            return "Color Clamp"
        }
    }
}

final class ImageFilters {
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    func applyBlurFilter(val: CGFloat, filterType: FilterType) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return .init() }
        let blurFilter = CIFilter(name: filterType.rawValue)
        
        switch filterType {
        case .colorClamp:
            blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
            blurFilter?.setValue(CIVector(x: 0.1, y: 0.1, z: 0.1, w: 0), forKey: "inputMinComponents")
            blurFilter?.setValue(CIVector(x: 0.3, y: 0.3, z: 0.3, w: 1), forKey: "inputMaxComponents")

        }
        
        let rect = ciImage.extent
        let context = CIContext(options: nil)
        if let output = blurFilter?.outputImage,
           let cgimg = context.createCGImage(output, from: rect) {
            return UIImage(cgImage: cgimg)
        }
        fatalError()
    }
}


/*
 CIColorClamp - At each pixel, color component values less than those in inputMinComponents
 will be increased to match those in inputMinComponents, and color component values greater
 than those in inputMaxComponents will be decreased to match
 those in inputMaxComponents.
 */
