//
//  ViewModelProvider.swift
//  ReMVVM
//
//  Created by Dariusz Grzeszczak on 29/01/2018.
//  Copyright © 2018 Dariusz Grzeszczak. All rights reserved.
//

import MVVM

public struct ViewModelProvider {

    private let state: () -> StoreState
    private let subject: AnyStateSubject
    public init<State: StoreState>(with store: Store<State>) {
        state = { store.state }
        subject = store
    }

    public func viewModel<VM: ViewModel>(for context: ViewModelContext, for key: String? = nil) -> VM? {
        let factory = MVVMViewModelFactory(key: key, factory: state().factory)
        return ViewModelProviders.provider(for: context, with: factory).get(for: key)
    }

    public func viewModel<VM: ViewModel>(for context: ViewModelContext, for key: String? = nil) -> VM? where VM: StateSubscriber {
        let factory = MVVMViewModelFactory(key: key, factory: state().factory)
        guard let vm: VM = ViewModelProviders.provider(for: context, with: factory).get(for: key) else { return nil }
        subject.add(subscriber: vm)

        return vm
    }

    public func clear(context: ViewModelContext) {
        ViewModelStores.store(for: context).clear()
    }
}

private struct MVVMViewModelFactory: MVVM.ViewModelFactory {
    let key: String?
    let factory: ViewModelFactory
    func create<VM>() -> VM? {
        return factory.create(key: key)
    }

    init(key: String?, factory: ViewModelFactory) {
        self.key = key
        self.factory = factory
    }
}
