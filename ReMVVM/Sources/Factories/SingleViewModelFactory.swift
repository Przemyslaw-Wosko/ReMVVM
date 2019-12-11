//
//  SingleViewModelFactory.swift
//  ReMVVM
//
//  Created by Dariusz Grzeszczak on 29/01/2018.
//  Copyright © 2018 Dariusz Grzeszczak. All rights reserved.
//

import MVVM

/// Helper implementation of view model factory that creates view models based on closure given in initializer.
public struct SingleViewModelFactory<SVM: ViewModel>: ViewModelFactory {

    private let factory: (String?) -> SVM?

    public init(with factory: @escaping (String?) -> SVM?) {
        self.factory = factory
    }

    public func creates<VM: ViewModel>(type: VM.Type) -> Bool {
        guard type == SVM.self else { return false }
        return true
    }

    public func create<VM: ViewModel>(key: String?) -> VM? {
        guard creates(type: VM.self) else { return nil }
        return factory(key) as? VM
    }
}
