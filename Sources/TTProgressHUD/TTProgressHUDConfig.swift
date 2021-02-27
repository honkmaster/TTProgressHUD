//
//  TTProgressHUDConfig.swift
//  TTProgessHUD
//
//  Created by Tobias Tiemerding on 31.07.20.
//

import SwiftUI

public struct TTProgressHUDConfig: Hashable
{
    var type = TTProgressHUDType.Loading
    var title:String?
    var caption:String?
    
    var minSize:CGSize
    var cornerRadius:CGFloat
    
    var backgroundColor:Color
    
    var titleForegroundColor:Color
    var captionForegroundColor:Color
    
    var shadowColor:Color
    var shadowRadius:CGFloat
    
    var borderColor:Color
    var borderWidth:CGFloat
    
    var lineWidth:CGFloat
    
    var imageViewSize:CGSize // indefinite animated view and image share the size
    var imageViewForegroundColor:Color // indefinite animated view and image share the color
    
    var successImage:String
    var warningImage:String
    var errorImage:String
    
    // Auto hide
    var shouldAutoHide:Bool
    var allowTapToHide:Bool
    var autoHideInterval:TimeInterval
    
    // Haptics
    var hapticsEnabled:Bool
    
    // All public structs need a public init
    public init(type:TTProgressHUDType         = .Loading,
                title:String?                  = nil,
                caption:String?                = nil,
                minSize:CGSize                 = CGSize(width: 100.0, height: 100.0),
                cornerRadius:CGFloat           = 12.0,
                backgroundColor:Color          = .clear,
                titleForegroundColor:Color     = .primary,
                captionForegroundColor:Color   = .secondary,
                shadowColor:Color              = .clear,
                shadowRadius:CGFloat           = 0.0,
                borderColor:Color              = .clear,
                borderWidth:CGFloat            = 0.0,
                lineWidth:CGFloat              = 10.0,
                imageViewSize:CGSize           = CGSize(width: 100, height: 100), // indefinite animated view and image share the size
                imageViewForegroundColor:Color = .primary,                        // indefinite animated view and image share the color
                successImage:String            = "checkmark.circle",
                warningImage:String            = "exclamationmark.circle",
                errorImage:String              = "xmark.circle",
                shouldAutoHide:Bool            = false,
                allowTapToHide:Bool            = false,
                autoHideInterval: TimeInterval = 10.0,
                hapticsEnabled:Bool            = true)
    {
        self.type = type
        
        self.title = title
        self.caption = caption
        
        self.minSize = minSize
        self.cornerRadius = cornerRadius
        
        self.backgroundColor = backgroundColor
        
        self.titleForegroundColor = titleForegroundColor
        self.captionForegroundColor = captionForegroundColor
        
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        
        self.lineWidth = lineWidth
        
        self.imageViewSize = imageViewSize
        self.imageViewForegroundColor = imageViewForegroundColor
        
        self.successImage = successImage
        self.warningImage = warningImage
        self.errorImage = errorImage
        
        self.shouldAutoHide = shouldAutoHide
        self.allowTapToHide = allowTapToHide
        self.autoHideInterval = autoHideInterval
        
        self.hapticsEnabled = hapticsEnabled
    }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
