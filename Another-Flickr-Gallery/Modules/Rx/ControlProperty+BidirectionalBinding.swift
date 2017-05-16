//
// Created by Adam Borek on 17.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ControlProperty where PropertyType: Equatable {
    func bidirectionalBind(with variable: Variable<PropertyType>) -> Disposable {

        let writeToVariableDisposable = self
                .skipUntil(variable.asObservable())
                .bind(to: variable)

        let readingFromVariableDisposable = variable
                .asObservable()
                .observeOn(MainScheduler())
                .distinctUntilChanged()
                .catchErrorJustComplete()
                .bind(to: self)

        return Disposables.create(readingFromVariableDisposable, writeToVariableDisposable)
    }
}
