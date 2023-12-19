//
//  PageView.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 19/12/2023.
//

import SwiftUI

struct PageView<Page: View>: View {
    var pages: [Page]

    var body: some View {
        PageViewController(pages: pages)
            .aspectRatio(3 / 2, contentMode: .fit)
    }
}

#Preview {
    let data = ["Page 1", "Page 2", "Page 3"]
    return PageView(pages: data.map { Text($0) })
}
