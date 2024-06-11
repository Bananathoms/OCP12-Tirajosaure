//
//  PasswordResetController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 11/06/2024.
//

import Foundation

class PasswordResetController: ObservableObject {
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    
    func requestPasswordReset() {
        guard email.isValidEmail else {
            SnackBarService.current.error("invalid_email".localized)
            return
        }
        
        isLoading = true
        UserService.current.requestPasswordReset(email: email) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success:
                SnackBarService.current.success("password_reset_email_sent".localized)
            case .failure(let error):
                SnackBarService.current.error(error.localizedDescription)
            }
        }
    }
}
