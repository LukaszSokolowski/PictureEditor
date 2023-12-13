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
    
    let columns = [
        GridItem(.adaptive(minimum: 72)),
        GridItem(.adaptive(minimum: 72)),
    ]
    
    @State private var originalImage = UIImage(imageLiteralResourceName: "RockyTheDoge")
    @State private var processedImage: UIImage? {
        didSet {
            tipRuleSatisfied()
        }
    }
    
    @State private var imageData: Data?
    @State private var imageSelection: PhotosPickerItem?
    @State private var pressesTheImage: Bool = false
    @State private var isRevertModalActive: Bool = false
    @State private var isBlurSelectionAvtive: Bool = false
    
    var bottomContainerImage: UIImage {
        pressesTheImage ? originalImage : processedImage ?? originalImage
    }
    
    var originalImageTip = OriginalImageTip()
    
    var revertChangesView: some View {
        PopupView(title: "Revert to original?",
                  content: "You cannot undo this action",
                  confirmButtonTitle: "Revert",
                  cancelButtonTitle: "Cancel",
                  confirmAction: {
            isRevertModalActive = false
            processedImage = nil
        },
                  cancelAction: {
            isRevertModalActive = false
        })
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
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundGradient()
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
                        
                        if isBlurSelectionAvtive {
                            GeometryReader { geometryReader in
                                VStack(spacing: Padding.small.rawValue) {
                                    Text("Select blur")
                                    ScrollView(.horizontal) {
                                        HStack(spacing: Padding.small.rawValue) {
                                            ForEach(BlurType.allCases, id: \.self) { blur in
                                                Button(blur.name) {
                                                    processedImage = Blur(image: processedImage ?? originalImage).applyBlurFilter(val: 32, filterType: blur)
                                                }
                                                .buttonStyle(GradientButton())
                                            }
                                        }
                                    }
                                    .scrollIndicators(.hidden)
                                }.frame(width: geometryReader.size.width)
                            }.frame(height: 64.0)
                        }
                        
                        VStack {
                            ForEach(FilterType.allCases, id: \.self) { blur in
                                Button(blur.name) {
                                    processedImage = ImageFilters(image: processedImage ?? originalImage).applyBlurFilter(val: 32, filterType: blur)
                                }.buttonStyle(GradientButton())
                            }
                        }
                        
                        Button("Blur options") {
                            isBlurSelectionAvtive.toggle()
                        }
                        .buttonStyle(GradientButton())
                        NavigationLink("Present image information", value: originalImage)
                            .buttonStyle(.bordered)
                            .foregroundColor(.black)
                            .padding(EdgeInsets(top: Padding.normal.rawValue, leading: .zero, bottom: .zero, trailing: .zero))
                    }.navigationDestination(for: UIImage.self) { originalImage in
                        ImageInfoView(passedImage: originalImage)
                    }
                }
                if isRevertModalActive {
                    revertChangesView
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
