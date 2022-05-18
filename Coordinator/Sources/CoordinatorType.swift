//
//  CoordinatorType.swift
//  Coordinator
//
//  Created by Andrii Vysotskyi on 21.04.2022.
//

public protocol CoordinatorType: RouterType {

    /// This method adds a child to a coordinator's children.
    func addChild<Coordinator: CoordinatorType>(_ coordinator: Coordinator)

    /// This method removes a child to a coordinator's children.
    func removeChild<Coordinator: CoordinatorType>(_ coordinator: Coordinator)

    /// Returns parent coordinator.
    /// - TODO: Parent is only needed to remove self as coordinator from him. Maybe replace with simple
    /// delegate or something similar?
    var parent: AnyCoordinator? { get set }

    /// Coordinator's children list.
    var children: [AnyCoordinator] { get }

    /// Starts coordinator.
    func start()
}
