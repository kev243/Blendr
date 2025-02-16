//
//  Utilities.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-29.
//

import Foundation
import UIKit


final class Utilities {
    static let shared = Utilities()
    private init () {}
    
    
   @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        // Utilisation de connectedScenes pour obtenir la scène active
        let controller = controller ?? UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
