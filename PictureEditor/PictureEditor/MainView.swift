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
    @GestureState private var isDetectingLongPress = false
    @State private var completedLongPress = false
    
    @State var originalImage = UIImage(imageLiteralResourceName: "RockyTheDoge")
    @State var processedImage: UIImage?
    
    @State var selectedItems: [PhotosPickerItem] = []
    @State var imageData: Data?
    @State var imageSelection: PhotosPickerItem?
    
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .updating($isDetectingLongPress) { currentState, gestureState, _ in
                gestureState = currentState
            }
            .onEnded { finished in
                completedLongPress = finished
            }
    }
    
    var bottomContainerImage: UIImage {
        isDetectingLongPress ? originalImage : processedImage ?? originalImage
    }
    
    var originalImageTip = OriginalImageTip()
    
    var body: some View {
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
                        .padding(.horizontal, Padding.small.rawValue)
                } else {
                    let _ = print("Update your OS or buy new device to see awesome tips!")
                }
                Image(uiImage: bottomContainerImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(Padding.small.rawValue)
                    .gesture(longPress)
            }.task {
                if #available(iOS 17.0, *) {
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                } else {
                    let _ = print("Update your OS or buy new device to see awesome tips!")
                }
            }
            Button("Equalize histogram") {
                processedImage = processImageWith(processMethod: .equalizeHistogram)
            }
            .foregroundColor(Color.black)
            .buttonStyle(.bordered)
            .shadow(radius: UIConstants.shadowRadius)
            .padding(EdgeInsets(top: Padding.normal.rawValue, leading: .zero, bottom: .zero, trailing: .zero))
            Button("Reflect image") {
                processedImage = processImageWith(processMethod: .reflectImage)
            }
            .foregroundColor(Color.black)
            .buttonStyle(.bordered)
            .shadow(radius: UIConstants.shadowRadius)
            .padding(EdgeInsets(top: Padding.normal.rawValue, leading: .zero, bottom: .zero, trailing: .zero))
            Spacer()
            
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
