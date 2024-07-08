//
//  SignUpView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var controller: SignUpController
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ReusableTextField(hint: $controller.firstName, icon: nil, title: LocalizedString.firstName.localized, fieldName: LocalizedString.firstName.localized)
                        .textContentType(.oneTimeCode)
                    ReusableTextField(hint: $controller.lastName, icon: nil, title: LocalizedString.lastName.localized, fieldName: LocalizedString.lastName.localized)
                        .textContentType(.oneTimeCode)
                    ReusableTextField(hint: $controller.email, icon: nil, title: LocalizedString.email.localized, fieldName: LocalizedString.email.localized)
                        .textContentType(.oneTimeCode)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    ReusableSecureField(hint: $controller.password, icon: nil, title: LocalizedString.password.localized, fieldName: LocalizedString.enterYourPassword.localized)
                        .textContentType(.oneTimeCode)
                    ReusableSecureField(hint: $controller.confirmPwd, icon: nil, title: LocalizedString.password.localized, fieldName: LocalizedString.confirmYourPassword.localized)
                        .textContentType(.oneTimeCode)
                    TextButton(
                        text: LocalizedString.continueButton.localized,
                        isLoading: controller.isLoading,
                        onClick: {
                            MixpanelEvent.signUpButtonClicked.trackEvent()
                            controller.signUp()
                        },
                        buttonColor: .oxfordBlue,
                        textColor: .antiqueWhite
                    )
                    Spacer()
                }
                .padding(.top, 10)
                .background(Color.skyBlue)
            }
            .background(Color.skyBlue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CustomHeader(title: LocalizedString.signupTitle.localized)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        let data = PreviewData.UserData.signUpSample
        let controller = SignUpController()
        controller.email = data.email
        controller.firstName = data.firstName
        controller.lastName = data.lastName
        controller.password = data.password
        controller.confirmPwd = data.confirmPwd
        return Group {
            SignUpView(controller: controller)
                .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
                .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
            SignUpView(controller: controller)
                .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
                .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
        }
    }
}
