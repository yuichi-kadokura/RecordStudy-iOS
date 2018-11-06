//
//  SettingView.swift
//  RecordStudy
//
//  Created by 角倉 優一 on 2018/09/26.
//  Copyright © 2018年 角倉 優一. All rights reserved.
//

import UIKit

protocol SettingView {
    var homeWorkLabel: UILabel! { set get }
    var studyLabel: UILabel! { set get }
    var homeWorkView: UIView! { set get }
    var studyView: UIView! { set get }
}
