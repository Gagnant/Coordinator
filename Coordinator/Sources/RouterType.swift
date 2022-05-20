//
//  RouterType.swift
//  Coordinator
//
//  Created by Andrii Vysotskyi on 21.04.2022.
//

public protocol RouterType: AnyObject {

    /// `RouteType` defines which routes can be triggered in a certain implementation.
    associatedtype RouteType: Coordinator.RouteType

    /// Triggers transition for given route.
    /// - Returns: `true` if implementation was able to trigger the transition.
    @discardableResult
    func trigger(route: RouteType) -> Bool
}
