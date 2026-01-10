//
//  ImageInfoView.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 15/10/2022.
//

import SwiftUI
import ImageIO

struct ImageInfoViewModel {
    private let imageDictionary: CFDictionary?
    
    init(imageData: Data) {
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
              let dictionary = CGImageSourceCopyPropertiesAtIndex(imageSource, .zero, nil) else {
            self.imageDictionary = nil
            return
        }
        
        self.imageDictionary = dictionary
    }
    
    var imageMetadata: ImageMetadata? {
        guard let nsDict = imageDictionary as NSDictionary? else { return nil }
        
        return .init(colorModel: nsDict[ImageMetadataKey.colorModel.rawValue] as? String,
                     height: nsDict[ImageMetadataKey.height.rawValue] as? Int,
                     width: nsDict[ImageMetadataKey.width.rawValue] as? Int,
                     profileName: nsDict[ImageMetadataKey.profileName.rawValue] as? String,
                     apertureValue: nsDict.value(forKeyPath: ImageMetadataKey.apertureValue.rawValue) as? String,
                     bodyMake: nsDict.value(forKeyPath: ImageMetadataKey.bodyMake.rawValue) as? String,
                     bodyModel: nsDict.value(forKeyPath: ImageMetadataKey.bodyModel.rawValue) as? String,
                     bodySerialNumber: nsDict.value(forKeyPath: ImageMetadataKey.bodySerialNumber.rawValue) as? String)
    }
}

struct ImageInfoView: View {
    let model: ImageInfoViewModel
    
    init(model: ImageInfoViewModel) {
        self.model = model
    }
    
    var imageWidth: String {
        "\(model.imageMetadata?.width ?? .zero)"
    }
    
    var imageHeight: String {
        "\(model.imageMetadata?.height ?? .zero)"
    }
    
    var colorSpace: String? {
        model.imageMetadata?.colorModel
    }
    
    var profileName: String? {
        model.imageMetadata?.profileName
    }
    
    var apertureValue: String? {
        model.imageMetadata?.apertureValue
    }
    
    var bodySerialNumber: String? {
        model.imageMetadata?.bodySerialNumber
    }
    
    var bodyMake: String? {
        model.imageMetadata?.bodyMake
    }
    
    var bodyModel: String? {
        model.imageMetadata?.bodyModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("Width: " + imageWidth + "px")
                Text("Height: " + imageHeight + "px")
                if let profileName {
                    Text("Profile name: " + profileName)
                }
                if let colorSpace {
                    Text("Color space: " + colorSpace)
                }
                if let apertureValue {
                    Text("Aperture value: " + apertureValue)
                }
                if let bodyMake {
                    Text("Body make: " + bodyMake)
                }
                if let bodyModel {
                    Text("Body model: " + bodyModel)
                }
                if let bodySerialNumber {
                    Text("Body serial number: " + bodySerialNumber)
                }
                //                PageView(pages: [PageOption(processedImage: processedImage),
                //                                 PageOption(processedImage: processedImage),
                //                                 PageOption(processedImage: processedImage)])
            }
        }
    }
}

struct ImageInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ImageInfoView(model: .init(imageData: .init()))
    }
}

extension UIImage {
    var typeIdentifier: String? {
        cgImage?.utType as String?
    }
}
