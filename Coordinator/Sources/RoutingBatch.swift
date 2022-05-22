//
//  RoutingBatch.swift
//  Coordinator
//
//  Created by Andrii Vysotskyi on 21.04.2022.
//

public struct RoutingBatch {

    public init(coordinator: CoordinatorType) {
        self.coordinator = coordinator
    }

    /// Starts transition to profile.
    public func trigger(routes: RouteType...) -> Bool {
        var nextCoordinator: CoordinatorType? = coordinator
        for route in routes {
            guard let coordinator = nextCoordinator else {
                assertionFailure("Unable to trigger route!")
                return false
            }
            let didTriggerRoute = route.execute(on: coordinator)
            guard didTriggerRoute else {
                assertionFailure("Unable to trigger route!")
                return false
            }
            nextCoordinator = coordinator.children.first(where: route.isExecutable(on:))
        }
        return true
    }

    private let coordinator: CoordinatorType
}

private extension RouteType {

    func execute(on coordinator: CoordinatorType) -> Bool {
        coordinator.router(for: Self.self)?.trigger(route: self) ?? false
    }

    func isExecutable(on coordinator: CoordinatorType) -> Bool {
        coordinator.router(for: Self.self) != nil
    }
}
