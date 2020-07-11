//
//  Constants+Them.Color.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

extension Constants.Theme {
  enum Color {}
}

extension Constants.Theme.Color {
    
    enum BrandColors { // TODO rename
        
        static var standardDay: UIColor {
            UIColor.from(dark: .init(hex: 0x64aff5),
                         light: .init(hex: 0x50B4FA))
        }
        
        static var standardNight: UIColor {
            UIColor.from(dark: .init(hex: 0x3f709b),
                         light: .init(hex: 0x32719C))
        }
    }
    
    enum ContentElement {
      
      static var title: UIColor {
        UIColor.from(dark: .init(hex: 0xFFFFFF),
                     light: .init(hex: 0x000000))
      }
    }
    
}
