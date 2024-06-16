//
//  CustomHeader.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 16/06/2024.
//

import SwiftUI

struct CustomHeader: View {
    var title: String
    var fontSize: CGFloat = 20
    var showBackButton: Bool = false
    var onBack: (() -> Void)?
    
    private func titleText() -> some View {
        Text(title)
            .font(.customFont(.nunitoBold, size: fontSize))
            .foregroundColor(.oxfordBlue)
            .frame(alignment: .topLeading)
    }
    
    var body: some View {
        HStack {
            if showBackButton, let onBack = onBack {
                Button(action: {
                    onBack()
                }) {
                    HStack {
                        IconNames.back.systemImage
                            .foregroundColor(.oxfordBlue)
                        self.titleText()
                        Spacer()
                    }
                }
            } else {
                self.titleText()
                Spacer()
            }
        }
        .padding(.leading, 20)
        .padding(.top, 30)
    }
}

struct CustomHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomHeader(title: "Sign In", fontSize: 20, showBackButton: false)
                .previewLayout(.sizeThatFits)
            
            CustomHeader(title: "Sign Up", fontSize: 24, showBackButton: true, onBack: {})
                .previewLayout(.sizeThatFits)
        }
    }
}


