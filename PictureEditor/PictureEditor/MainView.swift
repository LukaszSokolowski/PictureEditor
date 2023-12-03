//
//  MainView.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 14/10/2022.
//

import SwiftUI
import PhotosUI
import CoreTransferable

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
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                PhotoPicker(selection: $imageSelection).onChange(of: imageSelection) { selectedItem in
                    if let selectedItem {
                        selectedItem.loadTransferable(type: Data.self) { result in
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
                }.padding(Padding.normal.rawValue)
            }
            VStack(spacing: 32.0) {
                VStack {
                    Text("Original image")
                    Image(uiImage: originalImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(Padding.small.rawValue)
                }
                VStack {
                    Text("Processed image")
                    Image(uiImage: bottomContainerImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(Padding.small.rawValue)
                        .gesture(longPress)
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
            
        }
    }
    
    private func processImageWith(processMethod: ImageProcessMethod) -> UIImage {
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
