//
//  AnyViewableCoordinator.swift
//  Coordinator
//
//  Created by Andrii Vysotskyi on 17.05.2022.
//

public final class AnyViewableCoordinator<Content>: ViewableCoordinatorType {

    public init<Coordinator: ViewableCoordinatorType>(_ coordinator: Coordinator) where Coordinator.Content == Content {
        if let coordinator = coordinator as? AnyViewableCoordinator<Content> {
            self.base = coordinator.base
            self.coordinator = coordinator.coordinator
        } else {
            self.base = coordinator
            self.coordinator = AnyViewableCoordinatorBox(coordinator: coordinator)
        }
    }

    /// The value wrapped by this instance.
    ///
    /// The base property can be cast back to its original type using one of the type
    /// casting operators (as?, as!, or as).
    public let base: AnyObject

    public func addChild<Coordinator: CoordinatorType>(_ coordinator: Coordinator) {
        self.coordinator.addChild(coordinator)
    }

    public func removeChild<Coordinator: CoordinatorType>(_ coordinator: Coordinator) {
        self.coordinator.removeChild(coordinator)
    }

    public var parent: AnyCoordinator? {
        get { coordinator.parent }
        set { coordinator.parent = newValue }
    }

    public var children: [AnyCoordinator] {
        return coordinator.children
    }

    public func start() {
        coordinator.start()
    }

    @discardableResult
    public func trigger(route: Any) -> Bool {
        return coordinator.trigger(route: route)
    }

    public var view: Content {
        return coordinator.view
    }

    // MARK: - Private

    private let coordinator: AnyViewableCoordinatorBase<Content>
}

private class AnyViewableCoordinatorBase<Content>: ViewableCoordinatorType {

    func addChild<Coordinator: CoordinatorType>(_ coordinator: Coordinator) {
        fatalError("Must override")
    }

    func removeChild<Coordinator: CoordinatorType>(_ coordinator: Coordinator) {
        fatalError("Must override")
    }

    var parent: AnyCoordinator? {
        get { fatalError("Must override") }
        set { fatalError("Must override") }
    }

    var children: [AnyCoordinator] {
        fatalError("Must override")
    }

    func start() {
        fatalError("Must override")
    }

    func trigger(route: Any) -> Bool {
        fatalError("Must override")
    }

    var view: Content {
        fatalError("Must override")
    }
}

private final class AnyViewableCoordinatorBox<Coordinator: ViewableCoordinatorType>: AnyViewableCoordinatorBase<Coordinator.Content> {

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    override func addChild<Coordinator: CoordinatorType>(_ coordinator: Coordinator) {
        self.coordinator.addChild(coordinator)
    }

    override func removeChild<Coordinator: CoordinatorType>(_ coordinator: Coordinator) {
        self.coordinator.removeChild(coordinator)
    }

    override var parent: AnyCoordinator? {
        get { return coordinator.parent }
        set { coordinator.parent = newValue }
    }

    override var children: [AnyCoordinator] {
        return coordinator.children
    }

    override func start() {
        coordinator.start()
    }

    override func trigger(route: Any) -> Bool {
        guard let route = route as? Coordinator.RouteType else {
            assertionFailure("Unsupported route type")
            return false
        }
        return coordinator.trigger(route: route)
    }

    override var view: Content {
        return coordinator.view
    }

    // MARK: - Private Properties

    private let coordinator: Coordinator
}
