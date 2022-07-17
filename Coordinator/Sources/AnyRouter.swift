//
//  AnyRouter.swift
//  Coordinator
//
//  Created by Andrii Vysotskyi on 21.04.2022.
//

public final class AnyRouter<RouteType: Coordinator.RouteType>: RouterType {

    public init<Router: RouterType>(_ router: Router) where Router.RouteType == RouteType {
        triggerRoute = router.trigger(route:)
        base = router
    }

    @discardableResult
    public func trigger(route: RouteType) -> Bool {
        return triggerRoute(route)
    }

    /// The value wrapped by this instance.
    ///
    /// The base property can be cast back to its original type using one of the type
    /// casting operators (as?, as!, or as).
    public let base: AnyObject

    // MARK: -

    private let triggerRoute: (RouteType) -> Bool
}
