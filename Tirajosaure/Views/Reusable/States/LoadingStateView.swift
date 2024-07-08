//
//  LoadingStateView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 01/07/2024.
//

import SwiftUI

struct LoadingStateView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(2)
                .padding(.bottom, 20)
            Text(LocalizedString.loading.localized)
                .font(.customFont(.nunitoBold, size: 32))
            Spacer()
        }
    }
}

struct LoadingStateView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingStateView()
    }
}
