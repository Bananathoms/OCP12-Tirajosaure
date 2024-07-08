//
//  SettingsView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 15/06/2024.
//

import SwiftUI

struct SettingsView: View {
    @State private var isEditing = false
    @State private var selectedLanguage = LanguageController.shared.getCurrentLanguage()
    @State private var navigateToAdd = false
    @State private var userFirstName = UserDefaults.standard.string(forKey: UserDefaultsKeys.firstName.key) ?? DefaultValues.defaultFirstName
    @State private var userLastName = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastName.key) ?? DefaultValues.defaultLastName
    @State private var userEmail = UserDefaults.standard.string(forKey: UserDefaultsKeys.email.key) ?? DefaultValues.defaultEmail
    
    @ObservedObject private var languageController = LanguageController.shared
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(LocalizedString.language.localized)
                    .font(.headline)
                    .foregroundColor(.oxfordBlue)
                    .padding(.top)
                    .padding(.leading)
                
                VStack(spacing: 20) {
                    Menu {
                        ForEach(AppLanguage.allCases, id: \.self) { language in
                            Button(action: {
                                selectedLanguage = language.rawValue
                                languageController.setLanguage(languageCode: language.rawValue)
                            }) {
                                Text(language.displayName)
                                    .foregroundColor(selectedLanguage == language.rawValue ? .blue : .primary)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedLanguageDisplayName())
                                .font(.customFont(.nunitoRegular, size: 18))
                                .foregroundColor(.oxfordBlue)
                            Spacer()
                            Image(systemName: IconNames.chevronDown.rawValue)
                                .foregroundColor(.oxfordBlue)
                        }
                        .padding()
                        .background(Color.antiqueWhite)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.4), radius: 5)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
                
                Text(LocalizedString.userInformations.localized)
                    .font(.headline)
                    .foregroundColor(.oxfordBlue)
                    .padding(.top)
                    .padding(.leading)
                
                userInfoView
                
                Spacer()
                
                HStack {
                    Spacer()
                    TextButton(text: LocalizedString.logoutButton.localized, isLoading: false, onClick: {
                        UserService.current.logOut()
                    }, buttonColor: .customRed, textColor: .white)
                        .padding()
                    Spacer()
                }
                
            }
            .background(Color.skyBlue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomHeader(title: LocalizedString.settingsTab.localized, showBackButton: false, fontSize: 36)
                        .padding(.vertical)
                }
            }
            .padding(.top)
            .background(Color.skyBlue)
            .onAppear(perform: loadUserDefaults)
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name(DefaultValues.languageChanged))) { _ in
                self.selectedLanguage = languageController.getCurrentLanguage()
            }
        }
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .background(Color.thulianPink)
    }
    
    private var userInfoView: some View {
        VStack(alignment: .leading, spacing: 15) {
            userInfoItem(iconName: .personneFill, label: LocalizedString.firstName.rawValue.localized, value: userFirstName)
            userInfoItem(iconName: .personneFill, label: LocalizedString.lastName.rawValue.localized, value: userLastName)
            userInfoItem(iconName: .enveloppeFill, label: LocalizedString.email.rawValue.localized, value: userEmail)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.antiqueWhite)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.4), radius: 5)
        .padding(.horizontal)
    }
    
    private func userInfoItem(iconName: IconNames, label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            iconName.systemImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundColor(.oxfordBlue)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(label)
                    .font(.customFont(.nunitoBold, size: 18))
                    .foregroundColor(.oxfordBlue)
                Text(value)
                    .font(.customFont(.nunitoRegular, size: 16))
                    .foregroundColor(.oxfordBlue.opacity(0.8))
            }
        }
    }
    
    private func selectedLanguageDisplayName() -> String {
        if let language = AppLanguage(rawValue: selectedLanguage) {
            return language.displayName
        }
        return LocalizedString.selectLanguage.localized
    }
    
    private func loadUserDefaults() {
        if let firstName = UserDefaults.standard.string(forKey: UserDefaultsKeys.firstName.key) {
            userFirstName = firstName
        }
        if let lastName = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastName.key) {
            userLastName = lastName
        }
        if let email = UserDefaults.standard.string(forKey: UserDefaultsKeys.email.key) {
            userEmail = email
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
            .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
        SettingsView()
            .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
            .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
    }
}
