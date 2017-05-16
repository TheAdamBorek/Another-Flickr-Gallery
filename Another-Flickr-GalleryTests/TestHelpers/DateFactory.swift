//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation

func dateInUTC(year: Int, month: Int, day: Int, hour: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
    var calendar = Calendar.current
    let UTC = TimeZone(abbreviation: "UTC")!
    calendar.timeZone = UTC
    let dateComponents = DateComponents(timeZone: UTC, era: nil, year: year, month: month, day: day, hour: hour, minute: minutes, second: seconds)
    return calendar.date(from: dateComponents)!
}
