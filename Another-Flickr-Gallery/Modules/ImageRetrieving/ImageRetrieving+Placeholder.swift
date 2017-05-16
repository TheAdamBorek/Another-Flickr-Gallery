//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import RxSwiftExt

extension ImageRetrieving {
    func retrieveImage(for url: URLConvertible?, placeholder: UIImage) -> Driver<UIImage> {
        return retrieveImage(for: url)
                .asDriver(onError: .justComplete)
                .startWith(placeholder)
    }
}
