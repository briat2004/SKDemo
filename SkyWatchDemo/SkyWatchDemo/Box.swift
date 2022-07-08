//
//  Box.swift
//  SkyWatchDemo
//
//  Created by BruceWu on 2022/7/7.
//

import Foundation

class Box<T> {
    
    typealias Lisenter = (T) -> ()
    
    var lisenter: Lisenter?
    
    var value: T {
        didSet {
            lisenter?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ lisenter: Lisenter?) {
        self.lisenter = lisenter
    }
}
