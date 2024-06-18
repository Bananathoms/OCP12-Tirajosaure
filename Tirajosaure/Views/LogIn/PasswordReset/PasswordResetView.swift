//
//  PasswordResetView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 11/06/2024.
//

import SwiftUI

struct PasswordResetView: View {
    @ObservedObject var controller: PasswordResetController
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ReusableTextField(hint: $controller.email, icon: nil, title: LocalizedString.email.localized, fieldName: LocalizedString.email.localized)
                        .textContentType(.oneTimeCode)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    TextButton(
                        text: LocalizedString.resetPasswordButton.localized,
                        isLoading: controller.isLoading,
                        onClick: {
                            controller.requestPasswordReset()
                        },
                        buttonColor: .oxfordBlue,
                        textColor: .antiqueWhite
                    )
                    Spacer()
                }
            }
            .padding(.top, 10)
            .background(Color.skyBlue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CustomHeader(title: LocalizedString.resetPasswordTitle.localized)
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
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
