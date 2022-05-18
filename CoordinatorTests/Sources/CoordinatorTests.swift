//
//  CoordinatorTests.swift
//  CoordinatorTests
//
//  Created by Andrii Vysotskyi on 21.04.2022.
//

import XCTest
@testable import Coordinator
import SwiftUI

final class CoordinatorTests: XCTestCase {

    func testAddChildSetsParent() {
        let coordinator = Coordinator<RouteMock>()
        let child = CoordinatorMock()
        coordinator.addChild(AnyViewableCoordinator(child))
        XCTAssert(child.parent?.base === coordinator)
    }

    func testAddChildUpdatesChildren() {
        let coordinator = Coordinator<RouteMock>()
        let child = CoordinatorMock()
        coordinator.addChild(child)
        let hasChild = coordinator.children.map(\.base).contains { $0 === child }
        XCTAssert(hasChild)
    }
}

private enum RouteMock { }

private final class CoordinatorMock: Coordinator<RouteMock>, ViewableCoordinatorType {

    var view: some View {
        EmptyView()
    }
}
