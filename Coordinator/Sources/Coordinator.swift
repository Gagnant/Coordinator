//
//  Coordinator.swift
//  Coordinator
//
//  Created by Andrii Vysotskyi on 21.04.2022.
//

open class Coordinator<RouteType>: CoordinatorType {

    public init() {
        _children = []
    }

    open var parent: AnyCoordinator? {
        get { _parent?.coordinator }
        set {
            _parent = newValue.map(AnyCoordinatorWeakBox.init)
        }
    }

    /// The child coordinators that are currently in the hierarchy.
    /// When performing a transition, children are automatically added and removed from this array.
    open var children: [AnyCoordinator] {
        removeNotOperationalChildren()
        return _children
    }

    /// - NOTE: Coordinator is weakly referenced so make sure to keep reference to it elsewhere.
    open func addChild(_ coordinator: AnyCoordinator) {
        _children.append(coordinator)
        coordinator.parent = AnyCoordinator(self)
    }

    open func removeChild(_ coordinator: AnyCoordinator) {
        assert(coordinator.parent?.base === self)
        coordinator.parent = nil
        _children = _children.filter { $0.base !== coordinator.base }
    }

    open func start() {
        // NOP
    }

    /// - NOTE: Method could be called to automatically end child coordinators and perform clean-up. In case of fully
    /// custom implementation be sure to remove self from parent coordinator.
    open func end() {
        children.forEach { coordintor in
            coordintor.end()
        }
    }

    open func trigger(route: RouteType) -> Bool {
        fatalError("Not implemented")
    }

    open var isOperational: Bool {
        fatalError("Not implemented")
    }

    // MARK: - Private Properties

    private var _children: [AnyCoordinator]
    private var _parent: AnyCoordinatorWeakBox?

    // MARK: - Private Methods

    private func removeNotOperationalChildren() {
        _children = _children.filter { !$0.isOperational }
    }
}
