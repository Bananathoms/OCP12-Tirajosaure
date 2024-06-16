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
    var showEditButton: Bool = false
    var onBack: (() -> Void)?
    var onEdit: (() -> Void)?
    var isEditing: Bool = false
    
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
            if showEditButton, let onEdit = onEdit {
                Button(action: {
                    onEdit()
                }) {
                    Image(systemName: isEditing ? IconNames.checkmarkCircleFill.rawValue : IconNames.pencilCircleFill.rawValue)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.oxfordBlue)
                }
                .padding(.trailing, 20)
            }
        }
        .padding(.leading, 20)
        .padding(.top, 30)
    }
}

struct CustomHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomHeader(title: "Sign In", fontSize: 20, showBackButton: false, showEditButton: true, onEdit: {}, isEditing: true)
                .previewLayout(.sizeThatFits)
            
            CustomHeader(title: "Sign Up", fontSize: 24, showBackButton: true, showEditButton: true, onBack: {}, onEdit: {}, isEditing: false)
                .previewLayout(.sizeThatFits)
        }
    }
}
