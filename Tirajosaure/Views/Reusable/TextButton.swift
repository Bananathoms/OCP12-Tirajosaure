//
//  TextButton.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import SwiftUI

struct TextButton: View {
    
    let text: String
    let isLoading: Bool
    let onClick: () -> Void
    let buttonColor: Color
    let textColor: Color
    
    var body: some View {
        
        Button(action: {onClick()}) {

            if isLoading {
                ProgressView().tint(Color.oxfordBlue)
            }else {
                Text("\(text)")
                    .font(.headline)
                    .foregroundColor(textColor)
                    
            }

        }.frame(width: 170, height: 50)
            .background(buttonColor)
            .cornerRadius(40.0)
        .padding(20)
        .disabled(isLoading)
    }
}

struct TextButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach([PreviewData.TextButtonData.normal, PreviewData.TextButtonData.loading], id: \.self) { data in
                TextButton(
                    text: data.text,
                    isLoading: data.isLoading,
                    onClick: {},
                    buttonColor: data.buttonColor,
                    textColor: data.textColor
                )
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("TextButton - \(data == .normal ? "Normal" : "Loading")")
            }
        }
    }
}
