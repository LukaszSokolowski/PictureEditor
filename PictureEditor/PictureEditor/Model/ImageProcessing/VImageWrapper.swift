//
//  VImageWrapper.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 15/10/2022.
//

import UIKit
import Accelerate

struct VImageWrapper {
    ///Most functions of the Accelerate framework expect a flag parameter used to constrain or provide context to the function.
    ///For now there is no need to provide this, so I create this constant with "no flag" value
    let vNoFlags = vImage_Flags(kvImageNoFlags)
    
    var uiImage: UIImage
    var processedImage: UIImage?
    
    init(uiImage: UIImage) {
        self.uiImage = uiImage
    }
    
    //MARK: - Create image buffer from UIImage
    func createVImageBuffer(image: UIImage) -> vImage_Buffer? {
        guard let cgImage = uiImage.cgImage,
              let imageBuffer = try? vImage_Buffer(cgImage: cgImage)
        else { return nil }
        return imageBuffer
    }
    
    //MARK: - Convert image buffer to UIImage
    func convertToUIImage(buffer: vImage_Buffer) -> UIImage? {
        guard let originalCgImage = uiImage.cgImage,
              let format = vImage_CGImageFormat(cgImage: originalCgImage),
              let cgImage = try? buffer.createCGImage(format: format)
        else { return nil }
        let image = UIImage(cgImage: cgImage,
                            scale: 1.0,
                            orientation: uiImage.imageOrientation)
        return image
    }
    
    mutating func processImageWith(processMethod: ImageProcessMethod) {
        guard let image = uiImage.cgImage,
              var imageBuffer = createVImageBuffer(image: uiImage),
              var destinationBuffer = try? vImage_Buffer(
                width: image.width,
                height: image.height,
                bitsPerPixel: UInt32(image.bitsPerPixel)),
              let flippedBuffer = try? vImage_Buffer(
                width: image.height,
                height: image.width,
                bitsPerPixel: UInt32(image.bitsPerPixel))
        else {
            print("Error creating image buffers.")
            processedImage = nil
            return
        }
        
        defer {
            imageBuffer.free()
            destinationBuffer.free()
        }
        
        var error = kvImageNoError
        switch processMethod {
        case .equalizeHistogram:
            error = vImageEqualization_ARGB8888(
                &imageBuffer,
                &destinationBuffer,
                vNoFlags)
        case .horizontalReflection:
            error = vImageHorizontalReflect_ARGB8888(
                &imageBuffer,
                &destinationBuffer,
                vNoFlags)
        case .verticalReflection:
            error = vImageVerticalReflect_ARGB8888(
                &imageBuffer,
                &destinationBuffer,
                vNoFlags)
        case .rotateLeft:
            destinationBuffer = flippedBuffer
            error = vImageRotate90_ARGB8888(&imageBuffer,
                                            &destinationBuffer,
                                            UInt8(kRotate270DegreesClockwise),
                                            [0],
                                            vNoFlags)
        case .rotateRight:
            destinationBuffer = flippedBuffer
            error = vImageRotate90_ARGB8888(&imageBuffer,
                                            &destinationBuffer,
                                            UInt8(kRotate270DegreesCounterClockwise),
                                            [0],
                                            vNoFlags)
        case .blur(let blurWidth, let blurHeight):
            let oddWidth = UInt32(blurWidth) % 2 == 0 ? UInt32(blurWidth) + 1 : UInt32(blurWidth)
            let oddHeight = UInt32(blurHeight) % 2 == 0 ? UInt32(blurHeight) + 1 : UInt32(blurHeight)
            error = vImageTentConvolve_ARGB8888(&imageBuffer,
                                                &destinationBuffer,
                                                nil,
                                                0, 0,
                                                oddHeight, oddWidth,
                                                nil,
                                                vImage_Flags(kvImageEdgeExtend))
        }
        
        guard error == kvImageNoError else {
            printVImageError(error: error)
            processedImage = nil
            return
        }
        
        processedImage = convertToUIImage(buffer: destinationBuffer)
    }
    
    func getHistogram(_ image: WrappedImage) -> HistogramLevels? {
        guard let cgImage = image == .original ? uiImage.cgImage : processedImage?.cgImage,
              var imageBuffer = try? vImage_Buffer(cgImage: cgImage)
        else {
            return nil
        }
        
        defer {
            imageBuffer.free()
        }
        
        var redArray: [vImagePixelCount] = Array(repeating: 0, count: 256)
        var greenArray: [vImagePixelCount] = Array(repeating: 0, count: 256)
        var blueArray: [vImagePixelCount] = Array(repeating: 0, count: 256)
        var alphaArray: [vImagePixelCount] = Array(repeating: 0, count: 256)
        
        var error: vImage_Error = kvImageNoError
        
        redArray.withUnsafeMutableBufferPointer { rPointer in
            greenArray.withUnsafeMutableBufferPointer { gPointer in
                blueArray.withUnsafeMutableBufferPointer { bPointer in
                    alphaArray.withUnsafeMutableBufferPointer { aPointer in
                        
                        var histogram = [
                            rPointer.baseAddress, gPointer.baseAddress,
                            bPointer.baseAddress, aPointer.baseAddress
                        ]
                        
                        histogram.withUnsafeMutableBufferPointer { hPointer in
                            if let hBaseAddress = hPointer.baseAddress {
                                error = vImageHistogramCalculation_ARGB8888(
                                    &imageBuffer,
                                    hBaseAddress,
                                    vNoFlags
                                )
                            }
                        }
                    }
                }
            }
        }
        
        guard error == kvImageNoError else {
            printVImageError(error: error)
            return nil
        }
        
        return HistogramLevels(
            red: redArray,
            green: greenArray,
            blue: blueArray,
            alpha: alphaArray
        )
    }
}

extension VImageWrapper {
    ///This method converts the returned vImageError value to a Swift-friendly vImage.Error. It then prints the description to the console for debugging.
    func printVImageError(error: vImage_Error) {
        let errDescription = vImage.Error(vImageError: error).localizedDescription
        print("vImage Error: \(errDescription)")
    }
}
