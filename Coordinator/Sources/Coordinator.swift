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

    /// The child coordinators that are currently in the hierarchy.
    /// When performing a transition, children are automatically added and removed from this array.
    open var children: [AnyCoordinator] {
        removeNilChildren()
        return _children.compactMap(\.coordinator)
    }

    // MARK: - CoordinatorType

    /// - NOTE: Coordinator is weakly referenced so make sure to keep reference to elsewhere.
    open func addChild<Coordinator: CoordinatorType>(_ coordinator: Coordinator) {
        removeNilChildren()
        let box = WeakAnyCoordinatorBox(coordinator: coordinator)
        _children.append(box)
    }

    open func removeChild<Coordinator: CoordinatorType>(_ coordinator: Coordinator) {
        removeNilChildren()
        let wrappedCoordinator = AnyCoordinator(coordinator: coordinator)
        _children = _children.filter { $0.coordinator?.base !== wrappedCoordinator.base }
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

    // MARK: - Private Properties

    private var _children: [WeakAnyCoordinatorBox]

    // MARK: - Private Methods

    private func removeNilChildren() {
        _children = _children.filter { $0.coordinator != nil }
    }
}

private final class WeakAnyCoordinatorBox {

    var coordinator: AnyCoordinator? {
        return _coordinator()
    }

    init<Coordinator: CoordinatorType>(coordinator: Coordinator) {
        _coordinator = { [weak coordinator] in
            coordinator.map(AnyCoordinator.init)
        }
    }

    private let _coordinator: () -> AnyCoordinator?
}
