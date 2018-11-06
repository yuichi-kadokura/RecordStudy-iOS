//
//  ParsistManager.swift
//  RecordStudy
//
//  Created by 角倉 優一 on 2018/06/26.
//  Copyright © 2018年 角倉 優一. All rights reserved.
//

import Foundation

struct SettingModel: Codable {
    var homeWork: Date = Date.init(timeIntervalSince1970jp: 0)
    var study: Date = Date.init(timeIntervalSince1970jp: 0)
}

struct PerformModel: Codable {
    var homeWork: Date = Date.init(timeIntervalSince1970jp: 0)
    var study: Date = Date.init(timeIntervalSince1970jp: 0)
    var isAchieveHomeWork: Bool = false
    var isAchieveStudy: Bool = false
    var medal:Int = 0
}

struct MedalModel: Codable {
    var count: Int = 0
    var isNew: Bool = false
}

class ParsistManager {

    enum Key: String {
        case Setting = "setting"
        case Medals = "medals"
        case IsInitialized = "isInitialized"
    }
    static let medalCount = 79
    
    /// MARK: 日付毎の実績
    static func save(performModel: PerformModel, date: Date) {
        let data = try? JSONEncoder().encode(performModel)
        let key = date.toYMD()
        UserDefaults.standard.set(data, forKey: key)
    }

    static func load(date: Date) -> PerformModel {
        let key = date.toYMD()
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return PerformModel()
        }
        return try! JSONDecoder().decode(PerformModel.self, from: data)
    }
    
    /// MARK: 目標
    static func save(settingModel: SettingModel) {
        let data = try? JSONEncoder().encode(settingModel)
        UserDefaults.standard.set(data, forKey: ParsistManager.Key.Setting.rawValue)
    }
    
    static func loadSetting() -> SettingModel {
        guard let data = UserDefaults.standard.data(forKey: ParsistManager.Key.Setting.rawValue) else {
            return SettingModel()
        }
        return try! JSONDecoder().decode(SettingModel.self, from: data)
    }

    /// MARK: メダル
    static func save(medalModels: [MedalModel]) {
        let data = try? JSONEncoder().encode(medalModels)
        UserDefaults.standard.set(data, forKey: ParsistManager.Key.Medals.rawValue)
    }
    
    static func loadMedals() -> [MedalModel] {
        guard let data = UserDefaults.standard.data(forKey: ParsistManager.Key.Medals.rawValue) else {
            var medals: [MedalModel] = []
            for _ in 0..<medalCount {
                medals.append(MedalModel())
            }
            return medals
        }
        return try! JSONDecoder().decode([MedalModel].self, from: data)
    }
    
    /// MARK: 初期化済みフラグ
    static func save(isInitialized: Bool) {
        UserDefaults.standard.set(isInitialized, forKey: ParsistManager.Key.IsInitialized.rawValue)
    }
    
    static func loadIsInitialized() -> Bool {
        return UserDefaults.standard.bool(forKey: ParsistManager.Key.IsInitialized.rawValue)
    }
    
    /// MARK: debug
    static func debugPrint() {
        print("debugPrint start --------------------------------")
        let dic = UserDefaults.standard.dictionaryRepresentation()
        for (key, value) in dic {
            if String(describing: type(of: value)) == "__NSCFData" {
                if key == ParsistManager.Key.Medals.rawValue {
                    let model = ParsistManager.loadMedals()
                    print("\(key) : \(model)")
                } else if key == ParsistManager.Key.Setting.rawValue {
                    let model = try! JSONDecoder().decode(SettingModel.self, from: value as! Data)
                    print("\(key) : \(model)")
                } else {
                    let model = try! JSONDecoder().decode(PerformModel.self, from: value as! Data)
                    print("\(key) : \(model)")
                }
            }
        }
        print("debugPrint end --------------------------------")
    }
    
    /// デバッグ
    static func debug() {
        // 初期化
        let date = Date.init(year: 2018, month: 9, day: 19)
        var model = ParsistManager.load(date: date)
        model.isAchieveHomeWork = false
        model.isAchieveStudy = false
        ParsistManager.save(performModel: model, date: date)
    }
}
