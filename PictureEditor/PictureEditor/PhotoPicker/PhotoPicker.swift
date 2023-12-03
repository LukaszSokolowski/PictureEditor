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
        let _ = print("$pickerItemSelection \(pickerItemSelection)")
        PhotosPicker(selection: $pickerItemSelection,
                     matching: .images,
                     photoLibrary: .shared()) {
            Image(systemName: "pencil.circle.fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 30))
                .foregroundColor(.accentColor)
        }
    }
}
