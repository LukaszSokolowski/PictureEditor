//
//  PhotoPicker.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 03/12/2023.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Binding var pickerItemSelection: PhotosPickerItem?
    
    init(selection: Binding<PhotosPickerItem?>) {
        self._pickerItemSelection = selection
    }
    
    var body: some View {
        PhotosPicker(selection: $pickerItemSelection,
                     matching: .images,
                     photoLibrary: .shared()) {
            Image(systemName: Icons.plusCircle.rawValue)
                .symbolRenderingMode(.monochrome)
                .font(.system(size: UIConstants.iconSize))
                .foregroundColor(.black)
        }
    }
}
