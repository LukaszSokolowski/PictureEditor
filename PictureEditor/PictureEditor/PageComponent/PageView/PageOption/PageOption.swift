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
            PillButton(title: "Equalize histogram") {
                processedImage = processImageWith(processMethod: .equalizeHistogram)
            }
            PillButton(title: "Horizontal reflect") {
                processedImage = processImageWith(processMethod: .horizontalReflection)
            }
            PillButton(title: "Vertical reflect") {
                processedImage = processImageWith(processMethod: .verticalReflection)
            }
            PillButton(title: "Rotate left") {
                processedImage = processImageWith(processMethod: .rotateLeft)
            }
            PillButton(title: "Rotate right") {
                processedImage = processImageWith(processMethod: .rotateRight)
            }
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
