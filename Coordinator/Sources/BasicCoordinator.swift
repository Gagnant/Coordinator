//
//  BasicCoordinator.swift
//  Coordinator
//
//  Created by Andrii Vysotskyi on 21.04.2022.
//

open class BasicCoordinator<RouteType: Coordinator.RouteType>: CoordinatorType, RouterType, Identifiable {

    public init() {
        children = []
    }

    public private(set) var children: [CoordinatorType]

    open func addChild(_ coordinator: CoordinatorType) {
        let isChild = children.map(\.id).contains(coordinator.id)
        guard !isChild else {
            return
        }
        children.append(coordinator)
        coordinator.didMove(toParent: self)
    }

    open func removeChild(_ coordinator: CoordinatorType) {
        let childIndex = children.map(\.id).firstIndex(of: coordinator.id)
        guard let childIndex = childIndex else {
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
            removeFromParentTrampoline = nil
        }
    }

    open func removeFromParent() {
        guard let trampoline = removeFromParentTrampoline else {
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
