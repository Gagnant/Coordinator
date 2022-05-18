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
        set { _parent = newValue?.weak }
    }

    /// The child coordinators that are currently in the hierarchy.
    /// When performing a transition, children are automatically added and removed from this array.
    open var children: [AnyCoordinator] {
        return _children
    }

    /// - NOTE: Coordinator is weakly referenced so make sure to keep reference to it elsewhere.
    open func addChild<Coordinator: CoordinatorType>(_ coordinator: Coordinator) {
        guard coordinator.parent == nil else {
            assertionFailure("Given coordinator already has parent.")
            return
        }
        let _coordinator = AnyCoordinator(coordinator)
        _children.append(_coordinator)
        coordinator.parent = AnyCoordinator(self)
    }

    open func removeChild<Coordinator: CoordinatorType>(_ coordinator: Coordinator) {
        guard coordinator.parent?.base === self else {
            assertionFailure("Given coordinator is not a child of self.")
            return
        }
        let _coordinator = AnyCoordinator(coordinator)
        _children = _children.filter { $0.base !== _coordinator.base }
        coordinator.parent = nil
    }

    open func start() {
        // NOP
    }

    @discardableResult
    open func trigger(route: RouteType) -> Bool {
        fatalError("Must override!")
    }

    // MARK: - Private Properties

    private var _children: [AnyCoordinator]
    private var _parent: AnyCoordinatorWeakBox?
}
