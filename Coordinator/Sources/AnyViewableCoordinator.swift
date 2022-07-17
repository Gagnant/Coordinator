//
//  AnyViewableCoordinator.swift
//  Coordinator
//
//  Created by Andrii Vysotskyi on 19.05.2022.
//

public final class AnyViewableCoordinator<Content>: ViewableCoordinatorType {

    public init<Coordinator: ViewableCoordinatorType>(_ coordinator: Coordinator) where Coordinator.Content == Content {
        self.base = coordinator
        self.coordinator = AnyViewableCoordinatorBox(coordinator: coordinator)
    }

    /// The value wrapped by this instance.
    ///
    /// The base property can be cast back to its original type using one of the type
    /// casting operators (as?, as!, or as).
    public let base: AnyObject

    public var id: AnyHashable {
        self.coordinator.id
    }

    public func addChild(_ coordinator: CoordinatorType) {
        self.coordinator.addChild(coordinator)
    }

    public func removeChild(_ coordinator: CoordinatorType) {
        self.coordinator.removeChild(coordinator)
    }

    public func didMove(toParent coordinator: CoordinatorType?) {
        self.coordinator.didMove(toParent: coordinator)
    }

    public func removeFromParent() {
        coordinator.removeFromParent()
    }

    public var children: [CoordinatorType] {
        coordinator.children
    }

    public func start() {
        coordinator.start()
    }

    public func router<Route: Coordinator.RouteType>(for routeType: Route.Type) -> AnyRouter<Route>? {
        coordinator.router(for: routeType)
    }

    public var content: Content {
        coordinator.content
    }

    // MARK: - Private Properties

    private let coordinator: AnyViewableCoordinatorBase<Content>
}

private class AnyViewableCoordinatorBase<Content>: ViewableCoordinatorType {

    var id: AnyHashable {
        fatalError("Must override")
    }

    func addChild(_ coordinator: CoordinatorType) {
        fatalError("Must override")
    }

    func removeChild(_ coordinator: CoordinatorType) {
        fatalError("Must override")
    }

    func didMove(toParent coordinator: CoordinatorType?) {
        fatalError("Must override")
    }

    func removeFromParent() {
        fatalError("Must override")
    }

    var children: [CoordinatorType] {
        fatalError("Must override")
    }

    func start() {
        fatalError("Must override")
    }

    func router<Route: Coordinator.RouteType>(for routeType: Route.Type) -> AnyRouter<Route>? {
        fatalError("Must override")
    }

    var content: Content {
        fatalError("Must override")
    }
}

private final class AnyViewableCoordinatorBox<C: ViewableCoordinatorType>: AnyViewableCoordinatorBase<C.Content> {

    init(coordinator: C) {
        self.coordinator = coordinator
    }

    override var id: AnyHashable {
        self.coordinator.id
    }

    override func addChild(_ coordinator: CoordinatorType) {
        self.coordinator.addChild(coordinator)
    }

    override func removeChild(_ coordinator: CoordinatorType) {
        self.coordinator.removeChild(coordinator)
    }

    override func didMove(toParent coordinator: CoordinatorType?) {
        self.coordinator.didMove(toParent: coordinator)
    }

    override func removeFromParent() {
        coordinator.removeFromParent()
    }

    override var children: [CoordinatorType] {
        coordinator.children
    }

    override func start() {
        coordinator.start()
    }

    override func router<Route: Coordinator.RouteType>(for routeType: Route.Type) -> AnyRouter<Route>? {
        coordinator.router(for: routeType)
    }

    override var content: Content {
        return coordinator.content
    }

    // MARK: - Private Properties

    private let coordinator: C
}
