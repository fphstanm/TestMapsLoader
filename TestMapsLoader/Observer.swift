//
//  Observer.swift
//  TestMapsLoader
//
//  Created by Philip on 11.11.2019.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation

protocol Observable {
    func add(observer: Observer)
    func remove(observer: Observer)
    func notifyObservers()
}

protocol Observer {
    var id: String { get set }
    func update(value: Bool?)
}
