//
//  PreviewData.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 14/06/2024.
//

import Foundation
import SwiftUI
import ParseSwift

enum PreviewData {

    
    enum UserData {
          case signUpSample
          case signInSample
          
          var email: String {
              switch self {
              case .signUpSample, .signInSample:
                  return "test@example.com"
              }
          }
          
          var firstName: String {
              switch self {
              case .signUpSample:
                  return "John"
              case .signInSample:
                  return ""
              }
          }
          
          var lastName: String {
              switch self {
              case .signUpSample:
                  return "Doe"
              case .signInSample:
                  return ""
              }
          }
          
          var password: String {
              switch self {
              case .signUpSample, .signInSample:
                  return "Password123"
              }
          }
          
          var confirmPwd: String {
              switch self {
              case .signUpSample:
                  return "Password123"
              case .signInSample:
                  return ""
              }
          }
        
        static var sampleUserPointer: Pointer<User> {
            return Pointer<User>(objectId: "sampleUserId")
        }
      }
    
    enum SecureFieldData {
        case normal
        case withHint
        
        var hint: Binding<String> {
            switch self {
            case .normal:
                return .constant("")
            case .withHint:
                return .constant("test")
            }
        }
        
        var icon: String? {
            switch self {
            case .normal:
                return nil
            case .withHint:
                return "lock"
            }
        }
        
        var title: String {
            switch self {
            case .normal:
                return "Mot de passe"
            case .withHint:
                return "Mot de passe"
            }
        }
        
        var fieldName: String {
            switch self {
            case .normal:
                return "mdp"
            case .withHint:
                return "mdp"
            }
        }
    }
    
    enum TextFieldData {
        case email
        case username
        
        var hint: Binding<String> {
            switch self {
            case .email:
                return .constant("test@example.com")
            case .username:
                return .constant("testuser")
            }
        }
        
        var icon: String? {
            switch self {
            case .email:
                return "at"
            case .username:
                return "person"
            }
        }
        
        var title: String {
            switch self {
            case .email:
                return "E-mail"
            case .username:
                return "Username"
            }
        }
        
        var fieldName: String {
            switch self {
            case .email:
                return "E-mail"
            case .username:
                return "Username"
            }
        }
    }
    
    enum TextButtonData {
        case normal
        case loading
        
        var text: String {
            switch self {
            case .normal:
                return "Déconnexion"
            case .loading:
                return "Chargement..."
            }
        }
        
        var isLoading: Bool {
            switch self {
            case .normal:
                return false
            case .loading:
                return true
            }
        }
        
        var buttonColor: Color {
            switch self {
            case .normal:
                return .customRed
            case .loading:
                return .gray
            }
        }
        
        var textColor: Color {
            switch self {
            case .normal:
                return .white
            case .loading:
                return .white
            }
        }
    }
}
