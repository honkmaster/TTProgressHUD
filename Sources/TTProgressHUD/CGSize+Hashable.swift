//
//  CGSize+Hashable.swift
//  TTProgressHUD
//
//  Created by Tobias Tiemerding on 27.02.21.
//

import CoreGraphics

extension CGSize: Hashable {
     public func hash(into hasher: inout Hasher) {
         hasher.combine(width)
         hasher.combine(height)
     }
 }
