//
//  PopupView+Common.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 10/01/2026.
//

import SwiftUI

extension PopupView {
    static func revertChanges(
        onConfirm: (() -> ())?,
        onCancel: (() -> ())?
    ) -> PopupView {
        PopupView(title: "Revert to original?",
                  content: "You cannot undo this action",
                  confirmButtonTitle: "Revert",
                  cancelButtonTitle: "Cancel",
                  confirmAction: onConfirm,
                  cancelAction: onCancel)
    }
    
    static func exportImage(
        onConfirm: (() -> ())?,
        onCancel: (() -> ())?
    ) -> PopupView {
        PopupView(title: "Export Image?",
                  content: nil,
                  confirmButtonTitle: "OK",
                  cancelButtonTitle: "Cancel",
                  confirmAction: onConfirm,
                  cancelAction: onCancel)
    }
}
