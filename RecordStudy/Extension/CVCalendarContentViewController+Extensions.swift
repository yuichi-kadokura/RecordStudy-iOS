//
//  CVCalendarContentViewController+Extensions.swift
//  RecordStudy
//
//  Created by 角倉 優一 on 2018/09/24.
//  Copyright © 2018年 角倉 優一. All rights reserved.
//

import UIKit
import CVCalendar

extension CVCalendarContentViewController {
    public func refreshCalender() {
        for weekV in presentedMonthView.weekViews {
            for dayView in weekV.dayViews {
                dayView.preliminarySetup()
                dayView.supplementarySetup()
            }
        }
    }
}
