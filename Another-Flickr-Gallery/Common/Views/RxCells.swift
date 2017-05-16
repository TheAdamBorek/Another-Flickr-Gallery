//
// Created by Adam Borek on 15.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import UIKit
import NSObject_Rx

class RxTableViewCell: UITableViewCell {
    override func prepareForReuse() {
        rx_disposeBag = DisposeBag()
    }
}

class RxCollectionViewCell: UICollectionViewCell {
    override func prepareForReuse() {
        rx_disposeBag = DisposeBag()
    }
}
