//
// Created by Adam Borek on 15.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
protocol NibHaving {
    static var nibName: String { get }
}

extension NibHaving where Self: UIView {
    // swiftlint:disable variable_name
    static func fromNib(translatesAutoresizingMaskIntoConstraints: Bool = true) -> Self {
        guard let view = (nib().instantiate(withOwner: nil, options: nil).first { $0 is Self } as? Self)
                else { fatalError("No nib named: \(nibName)") }
        view.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        return view
    }

    static func nib() -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}

