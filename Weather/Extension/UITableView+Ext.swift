//
//  UITableView+Ext.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit


extension UITableView {
    
    func dequeue<Cell: UITableViewCell>(_ indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withIdentifier: String(describing: Cell.self), for: indexPath) as! Cell
    }
    
    func register(cellType: UITableViewCell.Type) {
        let nib = UINib(nibName: String(describing: cellType), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: cellType))
    }
}
