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
    func update(value: Double?)
}

final class ObservableImp: Observable {
    var value: Double? {
        didSet {
            notifyObservers()
        }
    }
    private var observers: [Observer] = []
    
    func add(observer: Observer) {
        observers.append(observer)
    }
    
    func remove(observer: Observer) {
        guard let index = observers.enumerated().first(where: { $0.element.id == observer.id })?.offset else { return }
        observers.remove(at: index)
    }
    
    func notifyObservers() {
        observers.forEach { $0.update(value: value) }
    }
}
