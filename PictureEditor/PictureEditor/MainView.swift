//
//  MainView.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 14/10/2022.
//

import SwiftUI

struct MainView: View {
    @State var originalImage = UIImage(imageLiteralResourceName: "RockyTheDoge")
    @State var processedImage: UIImage?
       
    var body: some View {
        VStack {
            VStack(spacing: 64.0) {
                VStack {
                    Text("Original image")
                    Image(uiImage: originalImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(3)
                }
                VStack {
                    Text("Processed image")
                    Image(uiImage: processedImage ?? originalImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(3)
                }
            }
            Button("Process image") {
                processedImage = process(image: originalImage)
            }
            .foregroundColor(Color.black)
            .buttonStyle(.bordered)
            .shadow(radius: 16)
            .padding(EdgeInsets(top: 16.0, leading: 0, bottom: 0, trailing: 0))
        }
    }
    
    private func process(image: UIImage) -> UIImage {
        let imageWrapper = VImageWrapper(uiImage: image)
        if let image = imageWrapper.processedImage {
            return image
        }
        return UIImage()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
