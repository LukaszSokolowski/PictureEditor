//
//  PageOption.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 21/12/2023.
//

import SwiftUI

struct PageOption: View {
    
    @State private var processedImage: UIImage
    
    init(processedImage: UIImage) {
        self.processedImage = processedImage
    }
    
    var body: some View {
        VStack {
            Button("Equalize histogram") {
                processedImage = processImageWith(processMethod: .equalizeHistogram)
            }
            .buttonStyle(GradientButton())
            Button("Horizontal reflect") {
                processedImage = processImageWith(processMethod: .horizontalReflection)
            }
            .buttonStyle(GradientButton())
            Button("Vertical reflect") {
                processedImage = processImageWith(processMethod: .verticalReflection)
            }
            .buttonStyle(GradientButton())
            Button("Rotate left") {
                processedImage = processImageWith(processMethod: .rotateLeft)
            }
            .buttonStyle(GradientButton())
            Button("Rotate right") {
                processedImage = processImageWith(processMethod: .rotateRight)
            }
            .buttonStyle(GradientButton())
        }
    }
    
    func processImageWith(processMethod: ImageProcessMethod) -> UIImage {
        var imageWrapper = VImageWrapper(uiImage: processedImage)
        imageWrapper.processImageWith(processMethod: processMethod)
        return imageWrapper.processedImage ?? UIImage()
    }
}

#Preview {
    PageOption(processedImage: .init())
}
