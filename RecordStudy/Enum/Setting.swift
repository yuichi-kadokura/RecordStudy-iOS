//
//  Setting.swift
//  RecordStudy
//
//  Created by 角倉 優一 on 2018/08/02.
//  Copyright © 2018年 角倉 優一. All rights reserved.
//

import Foundation
import UIKit

enum Setting {
    case homeWork
    case study
    
    // 配列から指定されたenumの値を返却します
    func getLabel(_ view: SettingView) -> UILabel {
        let dicLabel: [Setting: UILabel] = [.homeWork: view.homeWorkLabel, .study: view.studyLabel]
        return dicLabel[self]!
    }
    func getView(_ view: SettingView) -> UIView {
        let dicView: [Setting: UIView] = [.homeWork: view.homeWorkView, .study: view.studyView]
        return dicView[self]!
    }
    func load() -> Date {
        let model = ParsistManager.loadSetting()
        if self == Setting.homeWork {
            return model.homeWork
        }
        return model.study
    }
    
    func save(date: Date) {
        var model = ParsistManager.loadSetting()
        if self == Setting.homeWork {
            model.homeWork = date
        } else {
            model.study = date
        }
        ParsistManager.save(settingModel: model)
    }
}
