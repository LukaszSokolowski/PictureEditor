//
//  VImageWrapper.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 15/10/2022.
//

import UIKit
import Accelerate

struct VImageWrapper {
    ///Most Accelerate functions expect a flags parameter used to restrict or provide context to the function.
    ///For now I won’t need to provide this, so I create this cosntant with no flag at all
    let vNoFlags = vImage_Flags(kvImageNoFlags)
    
    var uiImage: UIImage
    var processedImage: UIImage?
    
    init(uiImage: UIImage) {
        self.uiImage = uiImage
        
        if let buffer = createVImage(image: uiImage),
          let converted = convertToUIImage(buffer: buffer) {
            processedImage = converted
        }
    }
    
    func createVImage(image: UIImage) -> vImage_Buffer? {
        guard let cgImage = uiImage.cgImage,
              let imageBuffer = try? vImage_Buffer(cgImage: cgImage)
        else { return nil }
        return imageBuffer
    }
    
    func convertToUIImage(buffer: vImage_Buffer) -> UIImage? {
        guard let originalCgImage = uiImage.cgImage,
              let format = vImage_CGImageFormat(cgImage: originalCgImage),
              let cgImage = try? buffer.createCGImage(format: format)
        else { return nil }
        let image = UIImage(cgImage: cgImage)
        return image
    }
}

extension VImageWrapper {
    ///This method converts the returned vImageError value to a Swift-friendly vImage.Error. It then prints the description to the console for debugging.
    func printVImageError(error: vImage_Error) {
        let errDescription = vImage.Error(vImageError: error).localizedDescription
        print("vImage Error: \(errDescription)")
    }
}
