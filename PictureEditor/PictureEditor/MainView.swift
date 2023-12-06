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
    @State private var originalImage = UIImage(imageLiteralResourceName: "RockyTheDoge")
    @State private var processedImage: UIImage? {
        didSet {
            tipRuleSatisfied()
        }
    }
    
    @State private var imageData: Data?
    @State private var imageSelection: PhotosPickerItem?
    @State private var pressesTheImage: Bool = false
    
    var bottomContainerImage: UIImage {
        pressesTheImage ? originalImage : processedImage ?? originalImage
    }
    
    var originalImageTip = OriginalImageTip()
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundGradient()
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
                        if #available(iOS 17.0, *) {
                            TipView(originalImageTip,
                                    arrowEdge: .bottom)
                            .tipBackground(.teal.opacity(0.2))
                            .tipImageSize(CGSize(width: UIConstants.iconSize,
                                                 height: UIConstants.iconSize))
                            .padding(.horizontal, Padding.small.rawValue)
                        }
                        Image(uiImage: bottomContainerImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(.rect(cornerRadius: 4))
                            .padding(Padding.small.rawValue)
                            .pressAndReleaseAction(pressing: $pressesTheImage, onRelease: {
                                tipActionPerformed()
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
                    Spacer()
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
                        Spacer()
                        NavigationLink("Present image information", value: originalImage)
                            .buttonStyle(.bordered)
                            .foregroundColor(.black)
                            .padding(EdgeInsets(top: Padding.normal.rawValue, leading: .zero, bottom: .zero, trailing: .zero))
                    }.navigationDestination(for: UIImage.self) { originalImage in
                        ImageInfoView(passedImage: originalImage)
                    }
                    Spacer()
                }
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

//MARK: - TipKit
private extension MainView {
    func tipRuleSatisfied() {
        if #available(iOS 17.0, *) {
            OriginalImageTip.orignalImageChanged.toggle()
        }
    }
    
    func tipActionPerformed() {
        if #available(iOS 17.0, *) {
            originalImageTip.invalidate(reason: .actionPerformed)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
