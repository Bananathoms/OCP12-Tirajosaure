//
//  PasswordResetView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 11/06/2024.
//

import SwiftUI

struct PasswordResetView: View {
    @ObservedObject var controller: PasswordResetController
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            CustomHeader(
                title: LocalizedString.resetPasswordTitle.localized,
                showBackButton: true,
                onBack: {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
            ScrollView {
                ReusableTextField(hint: $controller.email, icon: nil, title: LocalizedString.email.localized, fieldName: LocalizedString.email.localized)
                    .textContentType(.oneTimeCode)
                    .autocapitalization(.none) 
                    .keyboardType(.emailAddress)
                TextButton(text: LocalizedString.resetPasswordButton.localized, isLoading: controller.isLoading, onClick: {
                    controller.requestPasswordReset()
                }, buttonColor: .oxfordBlue, textColor: .antiqueWhite)
                Spacer()
            }
            .background(Color.skyBlue)
        }
        .background(Color.skyBlue)
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = PasswordResetController()
        return Group {
            PasswordResetView(controller: controller)
                .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
                .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
            PasswordResetView(controller: controller)
                .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
                .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
        }
    }
}
