//
//  BasicCoordinatorTests.swift
//  CoordinatorTests
//
//  Created by Andrii Vysotskyi on 21.04.2022.
//

import XCTest
@testable import Coordinator

final class BasicCoordinatorTests: XCTestCase {

    func testAddChildUpdatesChildren() {
        let coordinator = BasicCoordinator<Never>()
        let child = BasicCoordinator<Never>()
        coordinator.addChild(child)
        XCTAssert(coordinator.children.contains(where: { $0 === child }))
    }
}
