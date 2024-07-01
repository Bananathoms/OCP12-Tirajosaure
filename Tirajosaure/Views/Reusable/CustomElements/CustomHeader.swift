//
//  CustomHeader.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 16/06/2024.
//

import SwiftUI

struct CustomHeader: View {
    var title: String
    var showBackButton: Bool = true
    var fontSize: CGFloat = 20
    
    var body: some View {
        HStack {
            if showBackButton {
                IconNames.back.systemImage
            }
            Text(title)
                .font(.customFont(.nunitoBold, size: fontSize))
            
        }
        .foregroundColor(.oxfordBlue)
        .padding(.leading, 5)
        .padding(.top)
    }
}
