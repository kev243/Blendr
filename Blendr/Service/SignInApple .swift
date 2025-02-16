//
//  SignInApple .swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-28.
//

//import Foundation
//import AuthenticationServices
//import CryptoKit
//
//class SignInApple: NSObject {
//    
//    
//    fileprivate var currentNonce: String?
//    private var completionHandler: ((Result<SignInAppleResult,Error>) -> Void)?
//    
//    func startSignInWithAppleFlow(completion:@escaping (Result<SignInAppleResult,Error>) -> Void) {
//        
//        guard UIApplication.getTopViewController() != nil else {
//            completion(.failure(NSError()))
//            return
//        }
//       
//      let nonce = randomNonceString()
//        completionHandler = completion
//      currentNonce = nonce
//      let appleIDProvider = ASAuthorizationAppleIDProvider()
//      let request = appleIDProvider.createRequest()
//      request.requestedScopes = [.fullName, .email]
//      request.nonce = sha256(nonce)
//
//      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//      authorizationController.delegate = self
//      authorizationController.presentationContextProvider = self
//      authorizationController.performRequests()
//    }
//    
//    
//    private func randomNonceString(length: Int = 32) -> String {
//      precondition(length > 0)
//      var randomBytes = [UInt8](repeating: 0, count: length)
//      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
//      if errorCode != errSecSuccess {
//        fatalError(
//          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
//        )
//      }
//
//      let charset: [Character] =
//        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
//
//      let nonce = randomBytes.map { byte in
//        // Pick a random character from the set, wrapping around if needed.
//        charset[Int(byte) % charset.count]
//      }
//
//      return String(nonce)
//    }
//    
//    private func sha256(_ input: String) -> String {
//      let inputData = Data(input.utf8)
//      let hashedData = SHA256.hash(data: inputData)
//      let hashString = hashedData.compactMap {
//        String(format: "%02x", $0)
//      }.joined()
//
//      return hashString
//    }
//    
//  
//
//   
//
//}
//
//extension SignInApple: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return ASPresentationAnchor(frame: .zero)
//    }
//    
//  
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//       if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//         guard let nonce = currentNonce, let completion = completionHandler else {
//           fatalError("Invalid state: A login callback was received, but no login request was sent.")
//         }
//         guard let appleIDToken = appleIDCredential.identityToken else {
//           print("Unable to fetch identity token")
//             completion(.failure(NSError()))
//           return
//         }
//         guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//           print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
//             completion(.failure(NSError()))
//           return
//         }
//           let appleResult = SignInAppleResult(idToken: idTokenString, nonce: nonce)
//           completion(.success(appleResult))
//       }
//     }
//
//     func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//       // Handle error.
//       print("Sign in with Apple errored: \(error)")
//     }
//
//}
//
//extension UIViewController:ASAuthorizationControllerPresentationContextProviding{
//    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//    
//    
//}
//
//
//extension UIApplication {
//    class func getTopViewController(base: UIViewController? = UIApplication.shared.connectedScenes
//                                        .filter { $0.activationState == .foregroundActive }
//                                        .compactMap { $0 as? UIWindowScene }
//                                        .first?.windows
//                                        .filter { $0.isKeyWindow }.first?.rootViewController) -> UIViewController? {
//
//        if let nav = base as? UINavigationController {
//            return getTopViewController(base: nav.visibleViewController)
//
//        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
//            return getTopViewController(base: selected)
//
//        } else if let presented = base?.presentedViewController {
//            return getTopViewController(base: presented)
//        }
//        return base
//    }
//}
