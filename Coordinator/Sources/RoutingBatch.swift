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
        var nextCoordinators: [CoordinatorType] = [coordinator]
        for route in routes {
            guard let coordinator = nextCoordinators.first(where: route.isExecutable(on:)),
                  route.execute(on: coordinator) else {
                assertionFailure("Unable to trigger route!")
                return false
            }
            nextCoordinators = coordinator.children
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
