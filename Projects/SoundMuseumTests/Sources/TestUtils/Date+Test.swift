//
//  Date+Test.swift
//  SoundMuseumTests
//
//  Created by Gunter on 2020/10/25.
//

import Foundation

extension Date {
  public init(
    timeZone: TimeZone? = nil,
    year: Int? = nil,
    month: Int? = nil,
    day: Int? = nil,
    hour: Int? = nil,
    minute: Int? = nil,
    second: Int? = nil,
    millisecond: Int? = nil
  ) {
    let components = DateComponents(
      calendar: .current,
      timeZone: timeZone,
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      nanosecond: millisecond.map { $0 * 1000000 }
    )
    self.init(timeIntervalSinceReferenceDate: components.date!.timeIntervalSinceReferenceDate)
  }
}
