//
//  EmptyStateView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 01/07/2024.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.customFont(.nunitoBold, size: 20))
                .foregroundColor(.gray)
                .padding(.top, 40)
            Text(message)
                .font(.customFont(.nunitoRegular, size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 20)
                .padding(.top, 10)
            Spacer()
        }
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(title: "No Items Available", message: "Press the button to add items.")
    }
}
