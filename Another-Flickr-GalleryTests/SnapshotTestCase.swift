//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import FBSnapshotTestCase
@testable import Another_Flickr_Gallery

@objc final class ScreenSizes: NSObject {
    static let threePointFiveInchesPhoneFrame = CGRect(x: 0, y: 0, width: 320, height: 480)
    static let fourInchesPhoneFrame = CGRect(x: 0, y: 0, width: 320, height: 568)
    static let fourPointSevenInchesPhoneFrame = CGRect(x: 0, y: 0, width: 375, height: 667)
    static let iPadPortrait = CGRect(x: 0, y: 0, width: 768, height: 1024)
    static let iPadLandscape = CGRect(x: 0, y: 0, width: 1024, height: 768)
}

@objc class SnapshotTestCase: FBSnapshotTestCase {

    private let frames: [String : CGRect] = [
        "iPadPortraitFrame": ScreenSizes.iPadPortrait,
        "iPadLandscapeFrame": ScreenSizes.iPadLandscape,
        "threePointFivePhoneFrame": ScreenSizes.threePointFiveInchesPhoneFrame,
        "fourInchesPhoneFrame": ScreenSizes.fourInchesPhoneFrame,
        "fourPointSevenInchesPhoneFrame": ScreenSizes.fourPointSevenInchesPhoneFrame
    ]

    override func getReferenceImageDirectory(withDefault dir: String!) -> String! {
        return snapshotReferenceImageDirectory
    }

    func verifyForScreens(view: UIView, file: StaticString = #file, line: UInt = #line) {
        for (identifier, frame) in frames {
            verify(view: view, frame: frame, identifier: identifier, file: file, line: line)
        }
    }

    func verifyForScreens(view: UIView, file: StaticString = #file, line: UInt = #line, updateClosure: (CGRect) -> Void) {
        for (identifier, frame) in frames {
            updateClosure(frame)
            verify(view: view, frame: frame, identifier: identifier, file: file, line: line)
        }
    }

    func verify(view: UIView, frame: CGRect? = nil, identifier: String = "", file: StaticString = #file, line: UInt = #line) {
        if let frame = frame {
            view.frame = frame
        }
        view.layoutIfNeeded()
        FBSnapshotVerifyView(view, identifier: identifier, file: file, line: line)
        FBSnapshotVerifyLayer(view.layer, identifier: identifier, file: file, line: line)
    }
}
