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
                Image(systemName: "chevron.backward")
                    .foregroundColor(.oxfordBlue)
                    .padding(.leading, 20)
                Text("reset_password_title".localized)
                    .font(.nunitoBold(20))
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
                ReusableTextField(hint: $controller.email, icon: nil, title: "email".localized, fieldName: "email".localized)
                    .textContentType(.oneTimeCode)
                    .autocapitalization(.none) 
                    .keyboardType(.emailAddress)
                TextButton(text: "reset_password_button".localized, isLoading: controller.isLoading, onClick: {
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
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE")
            PasswordResetView(controller: controller)
                .previewDevice("iPhone 14 Pro")
                .previewDisplayName("iPhone 14 Pro")
        }
    }
}
