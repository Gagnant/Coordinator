//
//  ViewableCoordinatorType.swift
//  Coordinator
//
//  Created by Andrii Vysotskyi on 17.05.2022.
//

import UIKit

public protocol ViewableCoordinatorType: CoordinatorType {

    associatedtype Content

    /// View content.
    var view: Content { get }
}





protocol FooBuilder {
    func build() -> AnyViewableCoordinator<UIViewController>
}

func foo() {
    let builder: FooBuilder! = nil
    let coordinator = builder.build()
    
}
