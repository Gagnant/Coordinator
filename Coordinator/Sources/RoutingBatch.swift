//
//  RoutingBatch.swift
//  Coordinator
//
//  Created by Andrii Vysotskyi on 21.04.2022.
//

public struct RoutingBatch {

    public init<Coordinator: CoordinatorType>(coordinator: Coordinator) {
        self.coordinator = AnyCoordinator(coordinator)
    }

    /// Starts transition to profile.
    public func trigger(routes: Any...) -> Bool {
        var nextCoordinator: AnyCoordinator? = coordinator
        for route in routes {
            guard nextCoordinator != nil else {
                assertionFailure("Unable to trigger route!")
                return false
            }
            let didTriggerRoute = nextCoordinator?.trigger(route: route) ?? false
            guard didTriggerRoute else {
                assertionFailure("Unable to trigger route!")
                return false
            }
            nextCoordinator = nextCoordinator?.children.first
        }
        return true
    }

    private let coordinator: AnyCoordinator
}
