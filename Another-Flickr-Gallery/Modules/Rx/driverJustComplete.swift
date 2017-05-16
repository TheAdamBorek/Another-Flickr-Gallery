//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ErrorHandlingStrategies {
    case ignoreError
    case justComplete
}

extension ObservableConvertibleType {
    func asDriver(onError errorStrategy: ErrorHandlingStrategies) -> Driver<E> {
        switch errorStrategy {
            case .ignoreError:
                return asDriver(onErrorDriveWith: .never())
            case .justComplete:
                return asDriver(onErrorDriveWith: .empty())
        }
    }
}
