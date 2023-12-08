//
//  ImageProcessMethod.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 16/10/2022.
//

import Foundation

enum ImageProcessMethod {
    case equalizeHistogram
    case horizontalReflection
    case verticalReflection
    case rotateLeft
    case rotateRight
    case blur(Int)
}
