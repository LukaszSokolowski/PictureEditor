//
//  ImageInfoView.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 15/10/2022.
//

import SwiftUI
import ImageIO

enum ImageData: String {
    case colorModel = "ColorModel"
    case height = "PixelHeight"
    case width = "PixelWidth"
    case profileName = "ProfileName"
    case apertureValue = "{Exif}.ApertureValue"
    case bodyMake = "{TIFF}.Make"
    case bodyModel = "{TIFF}.Model"
    case bodySerialNumber = "{Exif}.BodySerialNumber"
}

struct ImageMetaData {
    let colorModel: String?
    let height: Int?
    let width: Int?
    let profileName: String?
    let apertureValue: String?
    let bodyMake: String?
    let bodyModel: String?
    let bodySerialNumber: String?
}

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
    
    var imageMetaData: ImageMetaData? {
        var imageData: ImageMetaData?
        if let nsDict = imageDictionary as NSDictionary? {
            print(nsDict)
            imageData = .init(colorModel: nsDict[ImageData.colorModel.rawValue] as? String,
                              height: nsDict[ImageData.height.rawValue] as? Int,
                              width: nsDict[ImageData.width.rawValue] as? Int,
                              profileName: nsDict[ImageData.profileName.rawValue] as? String,
                              apertureValue: nsDict.value(forKeyPath: ImageData.apertureValue.rawValue) as? String,
                              bodyMake: nsDict.value(forKeyPath: ImageData.bodyMake.rawValue) as? String,
                              bodyModel: nsDict.value(forKeyPath: ImageData.bodyModel.rawValue) as? String,
                              bodySerialNumber: nsDict.value(forKeyPath: ImageData.bodySerialNumber.rawValue) as? String)
        }
        return imageData
    }
}

struct ImageInfoView: View {
    let model: ImageInfoViewModel
    
    init(model: ImageInfoViewModel) {
        self.model = model
    }
    
    var imageWidth: String {
        "\(model.imageMetaData?.width ?? .zero)"
    }
    
    var imageHeight: String {
        "\(model.imageMetaData?.height ?? .zero)"
    }
    
    var colorSpace: String? {
        model.imageMetaData?.colorModel
    }
    
    var profileName: String? {
        model.imageMetaData?.profileName
    }
    
    var apertureValue: String? {
        model.imageMetaData?.apertureValue
    }
    
    var bodySerialNumber: String? {
        model.imageMetaData?.bodySerialNumber
    }
    
    var bodyMake: String? {
        model.imageMetaData?.bodyMake
    }
    
    var bodyModel: String? {
        model.imageMetaData?.bodyModel
    }
    
    var body: some View {
        ZStack {
            BackgroundGradient()
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
