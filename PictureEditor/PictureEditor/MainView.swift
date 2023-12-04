//
//  MainView.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 14/10/2022.
//

import SwiftUI
import PhotosUI
import TipKit

struct MainView: View {
    @State var originalImage = UIImage(imageLiteralResourceName: "RockyTheDoge")
    @State var processedImage: UIImage?
    @State var selectedItems: [PhotosPickerItem] = []
    @State var imageData: Data?
    @State var imageSelection: PhotosPickerItem?
    @State var pressesTheImage: Bool = false
    @State private var animateGradient = false
    
    var bottomContainerImage: UIImage {
        pressesTheImage ? originalImage : processedImage ?? originalImage
    }
    
    var gradientBackground: some View {
        LinearGradient(colors: [.white, .init(uiColor: .superLightBlue)],
                       startPoint: animateGradient ? .topLeading : .bottomLeading,
                       endPoint: animateGradient ? .bottomTrailing : .topTrailing)
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.linear(duration: 16.0).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
    }
    
    var originalImageTip = OriginalImageTip()
    
    var body: some View {
        ZStack {
            gradientBackground
            VStack {
                HStack {
                    Spacer()
                    PhotoPickerView(selection: $imageSelection)
                        .onChange(of: imageSelection) { selectedItem in
                            if let selectedItem {
                                handleTransferableDataFor(selectedItem)
                            }
                        }.padding(Padding.normal.rawValue)
                }
                VStack {
                    Text("Processed image")
                    if #available(iOS 17.0, *) {
                        TipView(originalImageTip, arrowEdge: .bottom)
                            .tipBackground(.teal.opacity(0.2))
                            .tipImageSize(CGSize(width: UIConstants.iconSize,
                                                 height: UIConstants.iconSize))
                            .padding(.horizontal, Padding.small.rawValue)
                    }
                    Image(uiImage: bottomContainerImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(Padding.small.rawValue)
                        .pressAndReleaseAction(pressing: $pressesTheImage, onRelease: {
                            if #available(iOS 17.0, *) {
                                originalImageTip.invalidate(reason: .actionPerformed)
                            }
                        })
                }.task {
                    if #available(iOS 17.0, *) {
                        try? Tips.resetDatastore() //Only for testing
                        try? Tips.configure([
                            .displayFrequency(.immediate),
                            .datastoreLocation(.applicationDefault)
                        ])
                    }
                }
                Button("Equalize histogram") {
                    processedImage = processImageWith(processMethod: .equalizeHistogram)
                    if #available(iOS 17.0, *) {
                        OriginalImageTip.orignalImageChanged.toggle()
                    }
                }
                .foregroundColor(Color.black)
                .buttonStyle(.bordered)
                .shadow(radius: UIConstants.shadowRadius)
                .padding(EdgeInsets(top: Padding.normal.rawValue, leading: .zero, bottom: .zero, trailing: .zero))
                Button("Reflect image") {
                    processedImage = processImageWith(processMethod: .reflectImage)
                    if #available(iOS 17.0, *) {
                        OriginalImageTip.orignalImageChanged.toggle()
                    }
                }
                .foregroundColor(Color.black)
                .buttonStyle(.bordered)
                .shadow(radius: UIConstants.shadowRadius)
                .padding(EdgeInsets(top: Padding.normal.rawValue, leading: .zero, bottom: .zero, trailing: .zero))
                Spacer()
            }
            
        }
    }
}

private extension MainView {
    func handleTransferableDataFor(_ item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let imageData):
                if let imageData {
                    self.imageData = imageData
                    self.originalImage = UIImage(data: imageData)!
                    self.processedImage = originalImage
                } else {
                    print("No supported content type found.")
                }
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func processImageWith(processMethod: ImageProcessMethod) -> UIImage {
        var imageWrapper = VImageWrapper(uiImage: processedImage ?? originalImage)
        imageWrapper.processImageWith(processMethod: processMethod)
        return imageWrapper.processedImage ?? UIImage()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
