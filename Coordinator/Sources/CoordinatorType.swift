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
    func addChild<Coordinator: CoordinatorType>(_ coordinator: Coordinator)

    /// This method removes a child to a coordinator's children.
    func removeChild<Coordinator: CoordinatorType>(_ coordinator: Coordinator)

    /// Starts coordinator.
    func start()

    /// Ends coordinator.
    func end()
}
