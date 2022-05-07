//
//  CoordinatorTests.swift
//  CoordinatorTests
//
//  Created by Andrii Vysotskyi on 21.04.2022.
//

import XCTest
@testable import Coordinator

final class CoordinatorTests: XCTestCase {

    func testAddChildSetsParent() {
        let coordinator = Coordinator<RouteMock>()
        let child = CoordinatorMock(isOperational: true)
        coordinator.addChild(AnyCoordinator(child))
        XCTAssert(child.parent?.base === coordinator)
    }

    func testAddChildUpdatesChildren() {
        let coordinator = Coordinator<RouteMock>()
        let child = CoordinatorMock(isOperational: true)
        coordinator.addChild(AnyCoordinator(child))
        let hasChild = coordinator.children.map(\.base).contains { $0 === child }
        XCTAssert(hasChild)
    }
}

private enum RouteMock { }

private final class CoordinatorMock: Coordinator<RouteMock> {

    init(isOperational: Bool) {
        _isOperational = isOperational
        super.init()
    }

    override var isOperational: Bool {
        return _isOperational
    }

    private let _isOperational: Bool
}
