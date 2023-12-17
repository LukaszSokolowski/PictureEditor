//
//  FilterType.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 13/12/2023.
//

import UIKit

enum FilterStrength {
    case soft
    case medium
    case hard
}

enum FilterType: String, CaseIterable {
    case colorClamp = "CIColorClamp"
    case colorControls = "CIColorControls"
    
    var name: String {
        switch self {
        case .colorClamp:
            return "Color Clamp"
        case .colorControls:
            return "Color Controls"
        }
    }
}

final class ImageFilters {
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    func applyBlurFilter(val: CGFloat = 0, filterType: FilterType, filterStrength: FilterStrength = .medium) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return .init() }
        let blurFilter = CIFilter(name: filterType.rawValue)
        
        switch filterType {
        case .colorClamp:
            blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
            switch filterStrength {
            case .soft:
                blurFilter?.setValue(CIVector(x: 0.1, y: 0.1, z: 0.1, w: 0), forKey: "inputMinComponents")
                blurFilter?.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 1), forKey: "inputMaxComponents")
            case .medium:
                blurFilter?.setValue(CIVector(x: 0.1, y: 0.1, z: 0.1, w: 0), forKey: "inputMinComponents")
                blurFilter?.setValue(CIVector(x: 0.6, y: 0.6, z: 0.6, w: 1), forKey: "inputMaxComponents")
            case .hard:
                blurFilter?.setValue(CIVector(x: 0.1, y: 0.1, z: 0.1, w: 0), forKey: "inputMinComponents")
                blurFilter?.setValue(CIVector(x: 0.4, y: 0.4, z: 0.4, w: 1), forKey: "inputMaxComponents")
            }
        case .colorControls:
            blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
            switch filterStrength {
            case .soft:
                blurFilter?.setValue(1.3, forKey: "inputSaturation")
                blurFilter?.setValue(0.8, forKey: "inputBrightness")
                blurFilter?.setValue(0.8, forKey: "inputContrast")
            case .medium:
                blurFilter?.setValue(2.0, forKey: "inputSaturation")
                blurFilter?.setValue(0.8, forKey: "inputBrightness")
                blurFilter?.setValue(0.8, forKey: "inputContrast")
            case .hard:
                blurFilter?.setValue(2.8, forKey: "inputSaturation")
                blurFilter?.setValue(0.8, forKey: "inputBrightness")
                blurFilter?.setValue(0.7, forKey: "inputContrast")
            }
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
