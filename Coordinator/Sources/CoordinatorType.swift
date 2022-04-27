//
//  CoordinatorType.swift
//  Coordinator
//
//  Created by Andrii Vysotskyi on 21.04.2022.
//

public protocol CoordinatorType: RouterType {

    /// Coordinator's children list.
    var children: [AnyCoordinator] { get }

    /// This method adds a child to a coordinator's children.
    func addChild(_ coordinator: AnyCoordinator)

    /// This method removes a child to a coordinator's children.
    func removeChild(_ coordinator: AnyCoordinator)

    /// Starts coordinator.
    func start()

    /// Ends coordinator.
    func end()
}

extension CoordinatorType {

    /// Ends all existing children.
    func endChildren() {
        children.forEach { coordinator in coordinator.end() }
    }
}
