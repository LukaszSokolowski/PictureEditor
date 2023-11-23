//
//  ImageInfoView.swift
//  PictureEditor
//
//  Created by Łukasz Sokołowski on 15/10/2022.
//

import SwiftUI

struct ImageInfoView: View {
    let firstLabelText: String
    let secondLabelText: String
    let thirdLabelText: String
    let fourthLabelText: String
    let fifthLabelText: String
    
    init(firstLabelText: String,
         secondLabelText: String,
         thirdLabelText: String,
         fourthLabelText: String,
         fifthLabelText: String) {
        self.firstLabelText = firstLabelText
        self.secondLabelText = secondLabelText
        self.thirdLabelText = thirdLabelText
        self.fourthLabelText = fourthLabelText
        self.fifthLabelText = fifthLabelText
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Text("Hello, World!")
        Text("Hello, World!")
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
    }
}

struct ImageInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ImageInfoView(firstLabelText: "Preview value 1",
                      secondLabelText: "Preview value 2",
                      thirdLabelText: "Preview value 3",
                      fourthLabelText: "Preview value 4",
                      fifthLabelText: "Preview value 5")
    }
}
