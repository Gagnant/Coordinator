//
//  ViewableCoordinatorType.swift
//  Coordinator
//
//  Created by Andrii Vysotskyi on 17.05.2022.
//

public protocol ViewableCoordinatorType: CoordinatorType {

    associatedtype Content

    /// View content.
    var content: Content { get }
}
