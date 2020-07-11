//
//  String+Localized.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation
// MARK: - String+Localized

extension String {
    
    /// Localized string
    public var localized: String {
        
        let bundlePath = Bundle.main.path(forResource: "en" as String?, ofType: "lproj")
        
        let Languagebundle = Bundle(path: bundlePath!)
        return NSLocalizedString(
            self,
            tableName: nil,
            bundle: Languagebundle!,
            value: "",
            comment: ""
        )
    }
    
    /// Localized string based on parameters
    ///
    /// - Parameters:
    ///   - bundle: The bundle
    ///   - tableName: The table name
    /// - Returns: The localized string
    public func localized(withBundle bundle: Bundle, tableName: String?) -> String {
        
        return NSLocalizedString(
            self,
            tableName: tableName ?? nil,
            bundle: bundle,
            value: "",
            comment: ""
        )
    }
}
