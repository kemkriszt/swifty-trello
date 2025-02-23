//
//  UIApplication+Extension.swift
//  Briefed
//
//  Created by Krisztián Kemenes on 10.02.2025.
//

#if canImport(UIKit)
import UIKit

extension UIApplication {
    /// The key window for the first found scene.
    /// **Caution:** Use only if you app doesn't support multiple scenes
    var firstKeyWindow: UIWindow? {
        return Self.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?
            .keyWindow
    }
}
#endif
