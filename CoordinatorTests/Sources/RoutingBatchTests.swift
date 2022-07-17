//
//  RoutingBatchTests.swift
//  CoordinatorTests
//
//  Created by Andrii Vysotskyi on 20.05.2022.
//

import XCTest
@testable import Coordinator

final class RoutingBatchTests: XCTestCase {

    func testRoutingBatch() {
        // Given
        let coordinator = MockCoordinator()
        let batch = RoutingBatch(coordinator: coordinator)

        // When
        let didTrigger = batch.trigger(routes: MockRoute.mock)

        // Then
        XCTAssert(didTrigger)
        XCTAssert(coordinator.latestRoute == .mock)
        XCTAssert(coordinator.triggerInvocationsCount == 1)
    }
}

enum MockRoute: RouteType {
    case mock
}

private class MockCoordinator: BasicCoordinator<MockRoute> {

    var latestRoute: MockRoute?

    var triggerInvocationsCount = 0

    override func trigger(route: MockRoute) -> Bool {
        latestRoute = route
        triggerInvocationsCount += 1
        return true
    }
}
