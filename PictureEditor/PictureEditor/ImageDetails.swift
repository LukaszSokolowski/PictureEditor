//
//  ImageDetails.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 30/03/2023.
//

import SwiftUI

struct ImageDetails: View {
    var body: some View {
        VStack {
            GeometryReader { geo in
                Text("Hello, World!")
                    .frame(width: geo.size.width * 0.9, height: 40)
                    .background(.red)
            }.background(.pink)
            
            Text("More text")
                .background(.blue)
        }.background(.yellow)
    }
}

struct ImageDetails_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetails()
    }
}
