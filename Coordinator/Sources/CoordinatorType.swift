//
//  CoordinatorType.swift
//  Coordinator
//
//  Created by Andrii Vysotskyi on 21.04.2022.
//

public protocol CoordinatorType: AnyObject {

    /// The stable identity of the entity associated with this instance.
    var id: AnyHashable { get }

    /// This method adds a child to a coordinator's children.
    /// If you are implementing your own coordinator, it must call the `didMove(toParent:)` method of the child
    /// coordinator as a part of implementation.
    func addChild(_ coordinator: CoordinatorType)

    /// This method removes a child to a coordinator's children.
    func removeChild(_ coordinator: CoordinatorType)

    /// Called after the coordinator is added or removed from a parent coordinator.
    /// - Parameter coordinator: The parent coordinator, or nil if there is no parent.
    func didMove(toParent coordinator: CoordinatorType?)

    /// Removes the coordinator from its parent if any.
    /// Method automatically calls the `didMove(toParent:)` method of the child coordinator after it removes the child.
    func removeFromParent()

    /// Coordinator's children list.
    var children: [CoordinatorType] { get }

    /// Starts coordinator.
    func start()

    /// This method can be used to retrieve router to trigger the route on if the coordinator is capable to do so.
    func router<Route: RouteType>(for routeType: Route.Type) -> AnyRouter<Route>?
}

extension CoordinatorType where Self: RouterType {

    public func router<Route: Coordinator.RouteType>(for routeType: Route.Type) -> AnyRouter<Route>? {
        return AnyRouter<RouteType>(router: self) as? AnyRouter<Route>
    }
}

extension CoordinatorType {

    public var id: AnyHashable {
        ObjectIdentifier(self)
    }
}
