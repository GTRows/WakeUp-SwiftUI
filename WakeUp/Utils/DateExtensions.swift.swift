//
//  DateExtensions.swift.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 4.06.2023.
//

import Foundation

extension Date {
    // Define a new initializer that accepts hour and minute parameters.
    init(hour: Int, minute: Int) {
        let calendar = Calendar.current
        let currentDate = Date()
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let newDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: dateComponents.date!)!
        self.init(timeInterval: 0, since: newDate)
    }
}
