//
//  SignInView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import SwiftUI
import Mixpanel

struct SignInView: View {
    @ObservedObject var controller: SignInController

    private func newAccount() -> some View {
        NavigationLink(destination: SignUpView(controller: SignUpController())) {
            VStack{
                Text(LocalizedString.noAccountPrompt.localized)
                    .font(.customFont(.nunitoRegular, size: 16))
                    .foregroundColor(.oxfordBlue)
                    .padding(.leading, 20)
                Text(LocalizedString.signupHere.localized)
                    .frame(alignment: .bottom)
                    .font(.customFont(.nunitoRegular, size: 14))
                    .foregroundColor(.oxfordBlue)
                    .padding([.leading, .bottom], 20)
            }
        }
    }
    
    private func forgotPassword() -> some View {
        NavigationLink(destination: PasswordResetView(controller: PasswordResetController())) {
            HStack {
                Spacer()
                Text(LocalizedString.forgotPassword.localized)
                    .font(.customFont(.nunitoRegular, size: 14))
                    .underline()
                    .foregroundColor(.oxfordBlue)
                    .padding(.trailing, 30)
                    .padding(.bottom, 25)
            }
        }
    }
    
    var body: some View {
        VStack{
            IconNames.logo.image
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.top, 60)
                .padding(.bottom, 10)
            NavigationView{
                VStack{
                    CustomHeader(title: LocalizedString.signinTitle.localized)
                    ReusableTextField(hint: $controller.email, icon: IconNames.at.rawValue, title: LocalizedString.email.localized, fieldName: LocalizedString.email.localized).textContentType(.oneTimeCode)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    ReusableSecureField(hint: $controller.password, icon: IconNames.lock.rawValue, title: LocalizedString.password.localized, fieldName: LocalizedString.enterYourPassword.localized).textContentType(.oneTimeCode)
                    forgotPassword()
                    TextButton(text: LocalizedString.signinButton.localized, isLoading: controller.isLoading, onClick: {
                        MixpanelEvent.loginButtonClicked.trackEvent()
                        controller.signIn()
                    }, buttonColor: .oxfordBlue, textColor: .white)
                    Spacer()
                    newAccount()
                }.background(Color.skyBlue) .ignoresSafeArea()
            }.navigationBarHidden(true).cornerRadius(20, corners: [.topLeft, .topRight])
        }.background(Color.thulianPink)
            .ignoresSafeArea()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        let data = PreviewData.UserData.signInSample
        let controller = SignInController()
        controller.email = data.email
        controller.password = data.password
        return Group {
            SignInView(controller: controller)
                .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
                .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
            SignInView(controller: controller)
                .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
                .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
        }
    }
}
