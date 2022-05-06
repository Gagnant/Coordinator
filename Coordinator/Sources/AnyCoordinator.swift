//
//  AnyCoordinator.swift
//  Coordinator
//
//  Created by Andrii Vysotskyi on 21.04.2022.
//

public final class AnyCoordinator: CoordinatorType {

    public init<Coordinator: CoordinatorType>(_ coordinator: Coordinator) {
        if let coordinator = coordinator as? AnyCoordinator {
            self.base = coordinator.base
            self.coordinator = coordinator.coordinator
            self.weak = coordinator.weak
        } else {
            self.weak = AnyCoordinatorWeakBox(coordinator)
            self.base = coordinator
            self.coordinator = AnyCoordinatorBox(coordinator: coordinator)
        }
    }

    /// The value wrapped by this instance.
    ///
    /// The base property can be cast back to its original type using one of the type
    /// casting operators (as?, as!, or as).
    public let base: AnyObject

    public func addChild(_ coordinator: AnyCoordinator) {
        self.coordinator.addChild(coordinator)
    }

    public func removeChild(_ coordinator: AnyCoordinator) {
        self.coordinator.removeChild(coordinator)
    }

    public func start() {
        coordinator.start()
    }

    public func end() {
        coordinator.end()
    }

    @discardableResult
    public func trigger(route: Any) -> Bool {
        return coordinator.trigger(route: route)
    }

    public var children: [AnyCoordinator] {
        return coordinator.children
    }

    public var parent: AnyCoordinator? {
        get { coordinator.parent }
        set { coordinator.parent = newValue }
    }

    public var isOperational: Bool {
        return coordinator.isOperational
    }

    // MARK: - Internal

    /// Returns box that weakly references value wrapped by this instance.
    let weak: AnyCoordinatorWeakBox

    // MARK: - Private

    private let coordinator: AnyCoordinatorBase
}

private class AnyCoordinatorBase: CoordinatorType {

    func addChild(_ coordinator: AnyCoordinator) {
        fatalError("Must override")
    }

    func removeChild(_ coordinator: AnyCoordinator) {
        fatalError("Must override")
    }

    func start() {
        fatalError("Must override")
    }

    func end() {
        fatalError("Must override")
    }

    func trigger(route: Any) -> Bool {
        fatalError("Must override")
    }

    var children: [AnyCoordinator] {
        fatalError("Must override")
    }

    var parent: AnyCoordinator? {
        get { fatalError("Must override") }
        set { fatalError("Must override") }
    }

    var isOperational: Bool {
        fatalError("Must override")
    }
}

private final class AnyCoordinatorBox<Coordinator: CoordinatorType>: AnyCoordinatorBase {

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    override func addChild(_ coordinator: AnyCoordinator) {
        self.coordinator.addChild(coordinator)
    }

    override func removeChild(_ coordinator: AnyCoordinator) {
        self.coordinator.removeChild(coordinator)
    }

    override func start() {
        coordinator.start()
    }

    override func end() {
        coordinator.end()
    }

    override func trigger(route: Any) -> Bool {
        guard let route = route as? Coordinator.RouteType else {
            assertionFailure("Unsupported route type")
            return false
        }
        return coordinator.trigger(route: route)
    }

    override var children: [AnyCoordinator] {
        return coordinator.children
    }

    override var parent: AnyCoordinator? {
        get { return coordinator.parent }
        set { coordinator.parent = newValue }
    }

    override var isOperational: Bool {
        return coordinator.isOperational
    }

    // MARK: - Private Properties

    private let coordinator: Coordinator
}

final class AnyCoordinatorWeakBox {

    var coordinator: AnyCoordinator? {
        return _coordinator()
    }

    init<Coordinator: CoordinatorType>(_ coordinator: Coordinator) {
        _coordinator = { [weak coordinator] in
            coordinator.map(AnyCoordinator.init)
        }
    }

    private let _coordinator: () -> AnyCoordinator?
}
