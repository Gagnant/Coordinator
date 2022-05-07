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
        set { setParentCoordinator(newValue) }
    }

    /// The child coordinators that are currently in the hierarchy.
    /// When performing a transition, children are automatically added and removed from this array.
    open var children: [AnyCoordinator] {
        removeNotOperationalChildren()
        return _children
    }

    /// - NOTE: Coordinator is weakly referenced so make sure to keep reference to it elsewhere.
    open func addChild(_ coordinator: AnyCoordinator) {
        guard coordinator.parent == nil else {
            assertionFailure("Given coordinator already has parent.")
            return
        }
        _children.append(coordinator)
        coordinator.parent = AnyCoordinator(self)
    }

    open func removeChild(_ coordinator: AnyCoordinator) {
        guard coordinator.parent?.base === self else {
            assertionFailure("Given coordinator is not a child of self.")
            return
        }
        _children = _children.filter { $0.base !== coordinator.base }
        coordinator.parent = nil
    }

    open func start() {
        // NOP
    }

    /// - NOTE: Method could be called to automatically end child coordinators and perform clean-up. In case of fully
    /// custom implementation be sure to remove self from parent coordinator.
    open func end() {
        children.forEach { coordintor in
            coordintor.end()
            removeChild(coordintor)
        }
    }

    @discardableResult
    open func trigger(route: RouteType) -> Bool {
        fatalError("Must override!")
    }

    open var isOperational: Bool {
        fatalError("Must override!")
    }

    // MARK: - Private Properties

    private var _children: [AnyCoordinator]
    private var _parent: AnyCoordinatorWeakBox?

    // MARK: - Private Methods

    private func removeNotOperationalChildren() {
        _children = _children.filter { !$0.isOperational }
    }

    private func setParentCoordinator(_ coordinator: AnyCoordinator?) {
        let children = coordinator?.children.map(\.base) ?? []
        let isParent = children.contains { $0 === self }
        guard isParent else {
            assertionFailure("Self is not a child of given coordinator.")
            return
        }
        _parent = coordinator?.weak
    }
}
