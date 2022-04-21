//
//  GenericRouter.swift
//  Coordinator
//
//  Created by Andrii Vysotskyi on 21.04.2022.
//

public final class GenericRouter<RouteType>: RouterType {

    public init<Router: RouterType>(router: Router) where Router.RouteType == RouteType {
        triggerRoute = router.trigger(route:)
    }

    @discardableResult
    public func trigger(route: RouteType) -> Bool {
        return triggerRoute(route)
    }

    // MARK: -

    private let triggerRoute: (RouteType) -> Bool
}
