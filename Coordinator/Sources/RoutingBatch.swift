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
            let existingChildrenIdentifiers = Set(coordinator.children.map(ObjectIdentifier.init))
            let didTriggerRoute = route.execute(on: coordinator)
            guard didTriggerRoute else {
                assertionFailure("Unable to trigger route!")
                return false
            }
            let newChildren = coordinator.children.filter { child in
                !existingChildrenIdentifiers.contains(ObjectIdentifier(child))
            }
            if newChildren.count > 1 {
                assertionFailure("More than one new child, this is not supported yet!")
            }
            nextCoordinator = newChildren.first
        }
        return true
    }

    private let coordinator: CoordinatorType
}

private extension RouteType {

    func execute(on coordinator: CoordinatorType) -> Bool {
        return coordinator.router(for: Self.self)?.trigger(route: self) ?? false
    }
}
