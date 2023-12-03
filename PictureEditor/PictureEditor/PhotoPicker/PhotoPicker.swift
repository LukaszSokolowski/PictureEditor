//
//  PhotoPicker.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 03/12/2023.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: View {
    @Binding var pickerItemSelection: PhotosPickerItem?
    
    init(selection: Binding<PhotosPickerItem?>) {
        self._pickerItemSelection = selection
    }
    
    var body: some View {
        PhotosPicker(selection: $pickerItemSelection,
                     matching: .images,
                     photoLibrary: .shared()) {
            Image(systemName: "plus.circle")
                .symbolRenderingMode(.monochrome)
                .font(.system(size: 32))
                .foregroundColor(.black)
        }
    }
}
