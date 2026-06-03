//
//  SCLExtensions.swift
//  SCLAlertView
//
//  Created by Christian Cabarrocas on 16/04/16.
//  Copyright © 2016 Alexey Poimtsev. All rights reserved.
//

import UIKit

extension Int {
    
    func toUIColor() -> UIColor {
        return UIColor(
            red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(self & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func toCGColor() -> CGColor {
        return self.toUIColor().cgColor
    }
}

extension UInt {
    
    func toUIColor() -> UIColor {
        return UIColor(
            red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(self & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func toCGColor() -> CGColor {
        return self.toUIColor().cgColor
    }
}

extension String {
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
}

// MARK: - iOS 12 compatibility

// These abstractions wrap APIs that are only available from iOS 13 onwards.
// Each keeps the original iOS 13+ call as-is behind an availability check and
// provides a sensible fallback so the library still compiles and runs on iOS 12.

extension UIColor {

    /// `UIColor.systemBackground` on iOS 13+, falling back to white on iOS 12.
    static var sclSystemBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }

    /// `UIColor.label` on iOS 13+, falling back to black on iOS 12.
    static var sclLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }
}

extension UIImage {

    /// `UIImage.withTintColor(_:)` on iOS 13+. On iOS 12 it redraws the image's
    /// alpha mask filled with the given colour to achieve the same tint.
    func sclTinted(with color: UIColor) -> UIImage {
        if #available(iOS 13.0, *) {
            return self.withTintColor(color)
        } else {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            defer { UIGraphicsEndImageContext() }
            guard let context = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
                return self
            }
            let rect = CGRect(origin: .zero, size: size)
            // UIKit's drawing origin is top-left whereas Core Graphics is bottom-left.
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.clip(to: rect, mask: cgImage)
            color.setFill()
            context.fill(rect)
            return UIGraphicsGetImageFromCurrentImageContext() ?? self
        }
    }
}

extension UIActivityIndicatorView.Style {

    /// `.medium` on iOS 13+, falling back to `.gray` on iOS 12.
    /// Public because it is referenced from `SCLAppearance.init`'s default argument.
    public static var sclDefault: UIActivityIndicatorView.Style {
        if #available(iOS 13.0, *) {
            return .medium
        } else {
            return .gray
        }
    }
}
