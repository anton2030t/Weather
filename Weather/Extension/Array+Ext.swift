//
//  Array+Ext.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation

extension Array {
    func filterDuplicate(_ keyValue:((AnyHashable...)->AnyHashable,Element)->AnyHashable) -> [Element] {
        func makeHash(_ params:AnyHashable ...) -> AnyHashable {
           var hash = Hasher()
           params.forEach{ hash.combine($0) }
           return hash.finalize()
        }
        var uniqueKeys = Set<AnyHashable>()
        return filter{uniqueKeys.insert(keyValue(makeHash,$0)).inserted}
    }
}
