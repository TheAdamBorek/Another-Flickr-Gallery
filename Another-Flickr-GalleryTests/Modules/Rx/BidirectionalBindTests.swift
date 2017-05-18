//
// Created by Adam Borek on 17.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
import RxBlocking
import NSObject_Rx
@testable import Another_Flickr_Gallery

final class BidirectionalBindTest: XCTestCase {
    func test_alwaysReadValueFromVariableFirst() {
        let variable = Variable("variable")
        let subject = BehaviorSubject(value: "subject")
        let controlProperty = ControlProperty(values: subject.asObservable(), valueSink: subject.asObserver())

        let subscription = controlProperty.bidirectionalBind(with: variable)

        XCTAssertEqual(variable.value, "variable")
        let subjectValue = try! subject.asObservable().toBlocking().first()!
        XCTAssertEqual(subjectValue, "variable")
        subscription.dispose()
    }

    func test_propagateValuesFromControlPropertyToVariable() {
        let variable = Variable("variable")
        let subject = BehaviorSubject(value: "subject")
        let controlProperty = ControlProperty(values: subject.asObservable(), valueSink: subject.asObserver())

        let subscription = controlProperty.bidirectionalBind(with: variable)

        subject.onNext("The message")
        XCTAssertEqual(variable.value, "The message")
        subscription.dispose()
    }
}
