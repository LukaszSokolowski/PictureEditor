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
    @State private var originalImage = UIImage(imageLiteralResourceName: "gpsTagged")
    @State private var processedImage: UIImage? {
        didSet {
            tipRuleSatisfied()
        }
    }
    
    @State private var imageData: Data?
    @State private var imageSelection: PhotosPickerItem?
    @State private var pressesTheImage: Bool = false
    @State private var isRevertModalActive: Bool = false
    @State private var isExportModalActive: Bool = false
    
    var bottomContainerImage: UIImage {
        pressesTheImage ? originalImage : processedImage ?? originalImage
    }
    
    var originalImageTip = OriginalImageTip()
    
    var revertChangesView: some View {
        PopupView.revertChanges {
            isRevertModalActive = false
            processedImage = nil
        } onCancel: {
            isRevertModalActive = false
        }
    }
    
    var exportImageModalView: some View {
        PopupView.exportImage {
            isExportModalActive = false
            let imageSaver = ImageSaver()
            imageSaver.writeToPhotoAlbum(image: processedImage ?? originalImage)
        } onCancel: {
            isExportModalActive = false
        }
    }
    
    @available(iOS 17.0, *)
    var tipView: some View {
        TipView(originalImageTip,
                arrowEdge: .bottom)
        .tint(.black)
        .tipBackground(.teal.opacity(0.2))
        .tipImageSize(CGSize(width: UIConstants.iconSize,
                             height: UIConstants.iconSize))
        .padding(.horizontal, Padding.small.rawValue)
    }
    
    var mainActionsView: some View {
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
    
    let backgroundGradient = LinearGradient(
        colors: [Color.red, Color.blue],
        startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        if processedImage != nil {
                            Button {
                                isRevertModalActive = true
                            } label: {
                                Image(systemName: Icons.revert)
                                    .symbolRenderingMode(.monochrome)
                                    .font(.system(size: UIConstants.iconSize))
                                    .foregroundColor(.black)
                            }.padding(Padding.normal.rawValue)
                        }
                        Spacer()
                        if let imageData {
                            NavigationLink(value: imageData) {
                                Image(systemName: Icons.imageInfo)
                                    .symbolRenderingMode(.monochrome)
                                    .font(.system(size: UIConstants.iconSize))
                                    .foregroundColor(.black)
                            }
                            .navigationDestination(for: Data.self) {
                                ImageInfoView(model: .init(imageData: $0))
                            }
                        }
                        PhotoPickerView(selection: $imageSelection)
                            .onChange(of: imageSelection) { selectedItem in
                                if let selectedItem {
                                    handleTransferableDataFor(selectedItem)
                                }
                            }.padding(Padding.normal.rawValue)
                        
                    }
                    VStack {
                        if #available(iOS 17.0, *) {
                            tipView
                        }
                        Image(uiImage: bottomContainerImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(.rect(cornerRadius: 4))
                            .padding(Padding.small.rawValue)
                            .pressAndReleaseAction(pressing: $pressesTheImage,
                                                   onRelease: {
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
                        mainActionsView
                        PillButton(title: "Export image") {
                            isExportModalActive = true
                        }
                    }
                }
                .background(Color(uiColor: .background))
                
                if isRevertModalActive {
                    revertChangesView
                }
                if isExportModalActive {
                    exportImageModalView
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


final class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
