//
//  KVObserver.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation

@objcMembers class KVObserver<T>: NSObject {

    private var valueObservation: NSKeyValueObservation? {
        didSet {
            oldValue?.invalidate()
        }
    }

    weak var observable: KVObservable<T>? {
        didSet {
            self.setObservation()
        }
    }

    var value: T? {
        return observable?.value
    }

    var closure: ((T) -> Void)?

    init(_ observable: KVObservable<T>) {
        self.observable = observable
        super.init()

        self.setObservation()
    }

    private func setObservation() {
        self.valueObservation = self.observable?.observe(\KVObservable<T>.changes, changeHandler: { [weak self](_, changes) in
            guard let newValue = self?.observable?.value else {
                return
            }
            self?.closure?(newValue)
        })
    }

    deinit {
        self.valueObservation?.invalidate()
    }

}

@objcMembers class KVObservable<T>: NSObject {
    var value: T {
        didSet {
            self.changes = (self.changes + 1) % 2
        }
    }
    dynamic var changes: Int = 0
    init(_ value: T) {
        self.value = value
    }
}
