//
//  RecordStudySegue.swift
//  RecordStudy
//
//  Created by 角倉 優一 on 2018/07/13.
//  Copyright © 2018年 角倉 優一. All rights reserved.
//

import Foundation

enum RecordStudySegue: String {
    case homeWork = "homeWorkSegue"
    case study = "studySegue"
    
    // 配列から指定されたenumを返却します
    static func getEnum(_ value: String) -> RecordStudySegue {
        return [RecordStudySegue.homeWork.rawValue: RecordStudySegue.homeWork, RecordStudySegue.study.rawValue: RecordStudySegue.study][value]!
    }
}
