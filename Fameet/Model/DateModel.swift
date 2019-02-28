//
//  DateModel.swift
//  FinalChallengeVessel
//
//  Created by Terretino on 31/01/19.
//  Copyright © 2019 Terretino. All rights reserved.
//

import Foundation

class DateModel {
    
    var numberOfDaysInMonth: [Int] = [31,28,31,30,31,30,31,31,30,31,30,31]
    let monthsArray: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "Oktober", "November", "December"]
    let monthsArrayShort: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dec"]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        print("start day adalah : \(day)")
        return day
    }
    
    func setupTodayDate(){
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
        firstWeekDayOfMonth = getFirstWeekDay()
    }
    
    func februaryAmbiguousDate() {
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numberOfDaysInMonth[currentMonthIndex-1] = 29
            print("curr month index : \(currentMonthIndex-1)")
            print("numberOfDaysInMonth[currentMonthIndex-1] : \(numberOfDaysInMonth[currentMonthIndex-1])")
        }
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex += 1
        currentYear = year
        
        //for leap year, make february month of 29 days
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numberOfDaysInMonth[monthIndex] = 29
            } else {
                numberOfDaysInMonth[monthIndex] = 28
            }
        }
        firstWeekDayOfMonth=getFirstWeekDay()
    }
}

extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}

