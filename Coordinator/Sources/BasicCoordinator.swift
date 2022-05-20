//
//  BasicCoordinator.swift
//  Coordinator
//
//  Created by Andrii Vysotskyi on 21.04.2022.
//

open class BasicCoordinator<RouteType: Coordinator.RouteType>: CoordinatorType, RouterType {

    public init() {
        children = []
    }

    public private(set) var children: [CoordinatorType]

    open func addChild(_ coordinator: CoordinatorType) {
        let isChild = children.contains { $0 === coordinator }
        guard !isChild else {
            assertionFailure("Attemped to add child that was already added previously.")
            return
        }
        children.append(coordinator)
        coordinator.didMove(toParent: self)
    }

    open func removeChild(_ coordinator: CoordinatorType) {
        let childIndex = children.firstIndex { $0 === coordinator }
        guard let childIndex = childIndex else {
            assertionFailure("Coordinator is not a child of self.")
            return
        }
        children.remove(at: childIndex)
        coordinator.didMove(toParent: nil)
    }

    open func didMove(toParent coordinator: CoordinatorType?) {
        if let coordinator = coordinator {
            guard removeFromParentTrampoline == nil else {
                assertionFailure("Coordinator is already have a parent.")
                return
            }
            removeFromParentTrampoline = { [weak coordinator, unowned self] in
                coordinator?.removeChild(self)
            }
        } else {
            if removeFromParentTrampoline == nil {
                assertionFailure("Coordinator does not have a parent.")
            }
            removeFromParentTrampoline = nil
        }
    }

    open func removeFromParent() {
        guard let trampoline = removeFromParentTrampoline else {
            assertionFailure("Parent coordinator is not set.")
            return
        }
        trampoline()
    }

    open func start() {
        // NOP
    }

    @discardableResult
    open func trigger(route: RouteType) -> Bool {
        fatalError("Must override!")
    }

    // MARK: - Private Properties

    private var removeFromParentTrampoline: (() -> Void)?
}
