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
    
    private func makeHeader() -> some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                IconNames.back.systemImage
                    .foregroundColor(.oxfordBlue)
                    .padding(.leading, 20)
                Text(LocalizedString.resetPasswordTitle.localized)
                    .font(.customFont(.nunitoBold, size: 20))
                    .foregroundColor(.oxfordBlue)
                    .padding([.top, .bottom, .trailing], 20)
                    .frame(alignment: .topLeading)
                Spacer()
            }
        }
    }
    
    var body: some View {
        VStack {
            self.makeHeader()
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
