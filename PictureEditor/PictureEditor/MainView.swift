//
//  MainView.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 14/10/2022.
//

import SwiftUI
import PhotosUI

struct MainView: View {
    @State var originalImage = UIImage(imageLiteralResourceName: "RockyTheDoge")
    @State var processedImage: UIImage?
    @GestureState private var isDetectingLongPress = false
    @State private var completedLongPress = false
    
    //TODO: - create view model and pass lines below
    
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct ProfileImage: Transferable {
        let image: Image
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
            #if canImport(AppKit)
                guard let nsImage = NSImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(nsImage: nsImage)
                return ProfileImage(image: image)
            #elseif canImport(UIKit)
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                return ProfileImage(image: image)
            #else
                throw TransferError.importFailed
            #endif
            }
        }
    }
    
    @State private(set) var imageState: ImageState = .empty
    
    @State var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ProfileImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
    
    
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .updating($isDetectingLongPress) { currentState, gestureState, _ in
                gestureState = currentState
            }
            .onEnded { finished in
                completedLongPress = finished
            }
    }
    
    var getImage: UIImage {
        isDetectingLongPress ? originalImage : processedImage ?? originalImage
    }
    
    var photoPicker: some View {
        PhotosPicker(selection: $imageSelection,
                     matching: .images,
                     photoLibrary: .shared()) {
            Image(systemName: "pencil.circle.fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 30))
                .foregroundColor(.accentColor)
        }
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 64.0) {
                VStack {
                    Text("Original image")
                    Image(uiImage: originalImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(Padding.small.rawValue)
                }
                VStack {
                    Text("Processed image")
                    Image(uiImage: getImage)
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
            photoPicker
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
