//
//  MainViewController.swift
//  RecordStudy
//
//  Created by 角倉 優一 on 2017/12/07.
//  Copyright © 2017年 角倉 優一. All rights reserved.
//

import UIKit
import CVCalendar

class MainViewController: UIViewController {

    @IBOutlet weak var calenderYobiView: CVCalendarMenuView!
    @IBOutlet weak var calenderView: CVCalendarView!

    let calendarObj = Calendar(identifier: .gregorian)
    var calendarDateComponents : DateComponents = DateComponents()
    
    /// カレンダーの翌月ボタン
    @IBOutlet weak var headerPrevBtn: UIButton!
    /// カレンダーの先月ボタン
    @IBOutlet weak var headerNextBtn: UIButton!
    /// カレンダーのヘッダータイトル
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var calenderHeaderView: UIView!
    /// 目標ラベル - 宿題
    @IBOutlet weak var homeWorkSettingLabel: UILabel!
    /// 目標ラベル - 勉強
    @IBOutlet weak var studySettingLabel: UILabel!
    /// 実績ラベル - 宿題
    @IBOutlet weak var homeWorkPerformLabel: UILabel!
    /// 実績ラベル - 勉強
    @IBOutlet weak var studyPerformLabel: UILabel!
    /// 達成アイコン - 宿題
    @IBOutlet weak var homeWorkAchieveIcon: UIImageView!
    /// 達成アイコン - 勉強
    @IBOutlet weak var studyAchieveIcon: UIImageView!
    /// ボタンのバッジ
    @IBOutlet weak var newImage: UIImageView!
    
    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var licenseLabel: UILabel!
    
    private var currentCalendar: Calendar?
    private var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentCalendar = Calendar(identifier: .gregorian)
        currentCalendar?.locale = Locale(identifier: "ja_JP")
        calenderYobiView.calendar = currentCalendar
        newImage.isHidden = true
        // フォアグラウンドの通知の登録
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.viewWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        setFontSize()
    }
    
    private func setFontSize() {
        if UIDevice.current.userInterfaceIdiom != .pad {
            return
        }
        headerTitle.font = UIFont.systemFont(ofSize: 40)
        headerPrevBtn.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        headerNextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        homeWorkSettingLabel.font = UIFont.systemFont(ofSize: 40)
        studySettingLabel.font = UIFont.systemFont(ofSize: 40)
        homeWorkPerformLabel.font = UIFont.systemFont(ofSize: 40)
        studyPerformLabel.font = UIFont.systemFont(ofSize: 40)
        for label in labels {
            label.font = UIFont.systemFont(ofSize: 40)
        }
        for button in buttons {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        }
        
    }
    
    // MARK: フォアグラウンドになった時
    @objc func viewWillEnterForeground(_ notification: Notification?) {
        if self.isViewLoaded && (self.view.window != nil) {
            if !currentDate.isInToday {
                setupLabels()
                refreshCalender()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        innerCalendar(moveMonth: 0)
        setupLabels()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calenderYobiView.commitMenuViewUpdate()
        calenderView.commitCalendarViewUpdate()
    }

    // 前へボタン
    @IBAction func tappedHeaderPrevBtn(_ sender: Any) {
        self.calenderView.loadPreviousView()
        innerCalendar(moveMonth: -1)
    }
    
    // 次へボタン
    @IBAction func tappedHeaderNextBtn(_ sender: Any) {
        calenderView.loadNextView()
        innerCalendar(moveMonth: 1)
    }
    
    /// ラベル達の設定
    private func setupLabels() {
        homeWorkSettingLabel.text = Setting.homeWork.load().toHmm()
        studySettingLabel.text = Setting.study.load().toHmm()
        let perform = ParsistManager.load(date: Date())
        homeWorkPerformLabel.text = perform.homeWork.toHmm()
        studyPerformLabel.text = perform.study.toHmm()
        homeWorkAchieveIcon.isHidden = !perform.isAchieveHomeWork
        studyAchieveIcon.isHidden = !perform.isAchieveStudy
        setupNewBatch()
    }
    
    private func setupNewBatch() {
        let medals = ParsistManager.loadMedals()
        var isExistNew = false
        for i in 0..<medals.count {
            if medals[i].isNew {
                isExistNew = true
                break
            }
        }
        newImage.isHidden = !isExistNew
    }
    
    /// Calenderリフレッシュ
    private func refreshCalender() {
        // refreshPresentedMonth()だとScrollViewが増えていくのでextensionで実装
        calenderView.contentController.refreshCalender()
        currentDate = Date()
    }
    
    /// カレンダー処理
    private func innerCalendar(moveMonth: Int) {
        let changeDate = calendarObj.date(byAdding: DateComponents(month: moveMonth), to: calenderView.presentedDate.convertedDate()!)
        
        let beforeDate = calendarObj.date(byAdding: DateComponents(month: -1), to: changeDate!)
        let afterDate = calendarObj.date(byAdding: DateComponents(month: 1), to: changeDate!)
        let beforeDateString = getCalendarLabel(date: beforeDate!, format: "M月")
        let afterDateString = getCalendarLabel(date: afterDate!, format: "M月")
        self.headerPrevBtn.setTitle(beforeDateString, for: .normal)
        self.headerNextBtn.setTitle(afterDateString, for: .normal)
        self.headerTitle.text = getCalendarLabel(date: changeDate!, format: "yyyy年M月")
    }

    /// カレンダーのラベル取得
    private func getCalendarLabel(date: Date, format: String) -> String {
        let calendarDateComponents = calendarObj.dateComponents([.year, .month], from: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = calendarObj.date(from: calendarDateComponents)
        let dateString = dateFormatter.string(from: date!)
        return dateString
    }

    // Storyboardで遷移時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if type(of: segue.destination) == ResultInputViewController.self {
            let vc = segue.destination as! ResultInputViewController
            vc.delegate = self
            vc.segue = RecordStudySegue.getEnum(segue.identifier!)
        }
    }
    
    /// 設定ボタン
    @IBAction func clickSetting(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc: SettingViewController = storyboard.instantiateInitialViewController() as! SettingViewController
        present(vc, animated: true, completion: nil)
    }
    
    /// メダルボタン
    @IBAction func clickMedal(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Medal", bundle: nil)
        let vc: MedalViewController = storyboard.instantiateInitialViewController() as! MedalViewController
        present(vc, animated: true, completion: nil)
    }
    
    /// 入力ボタン（宿題）
    @IBAction func clickInputHomeWork(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ResultInput", bundle: nil)
        let vc: ResultInputViewController = storyboard.instantiateInitialViewController() as! ResultInputViewController
        vc.delegate = self
        vc.segue = RecordStudySegue.homeWork
        present(vc, animated: true, completion: nil)
    }
    
    /// 入力ボタン（勉強）
    @IBAction func clickInputStudy(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ResultInput", bundle: nil)
        let vc: ResultInputViewController = storyboard.instantiateInitialViewController() as! ResultInputViewController
        vc.delegate = self
        vc.segue = RecordStudySegue.study
        present(vc, animated: true, completion: nil)
    }

    // 入力画面（設定or実績入力）から戻ってくるお（使ってるから消さないで！）
    @IBAction func returnToMe(segue: UIStoryboardSegue) {}

}

/// 入力から戻ってきました（実績入力画面）
extension MainViewController: ResultInputDelegate {
    func inputValue(date: Date, time: Date, segue: RecordStudySegue) {
        let getMedal = parsistResult(date: date, time: time, segue: segue)
        // viewWillAppearが発生するのでsetupLabels()は不要です
        refreshCalender()
        // Getメダル表示
        if getMedal >= 0 {
            let storyboard: UIStoryboard = UIStoryboard(name: "GetMedal", bundle: nil)
            let vc: GetMedalViewController = storyboard.instantiateInitialViewController() as! GetMedalViewController
            vc.medalNo = getMedal
            present(vc, animated: true, completion: nil)
        }
    }
    
    /// 永続化
    private func parsistResult(date: Date, time: Date, segue: RecordStudySegue) -> Int {
        var performModel = ParsistManager.load(date: date)
        var medalModels = ParsistManager.loadMedals()
        var getMedal = -1
        switch segue {
        case .homeWork:
            performModel.homeWork = time
            let settingDate = Setting.homeWork.load()
            // 初めてフラグ立った時にメダルゲット
            if time >= settingDate && !performModel.isAchieveHomeWork {
                performModel.isAchieveHomeWork = true
                getMedal = getLastMedal()
                setMedalModel(getMedal: getMedal, performModel: &performModel, medalModels: &medalModels)
            }
        case .study:
            performModel.study = time
            let settingDate = Setting.study.load()
            // 初めてフラグ立った時にメダルゲット
            if time >= settingDate && !performModel.isAchieveStudy {
                performModel.isAchieveStudy = true
                getMedal = getLastMedal()
                setMedalModel(getMedal: getMedal, performModel: &performModel, medalModels: &medalModels)
            }
        }
        ParsistManager.save(performModel: performModel, date: date)
        if getMedal >= 0 {
            ParsistManager.save(medalModels: medalModels)
        }
        return getMedal
    }
    
    /// メダルの設定
    private func setMedalModel(getMedal: Int, performModel: inout PerformModel, medalModels: inout [MedalModel]) {
        performModel.medal = getMedal
        if medalModels[getMedal].count == 0 {
            medalModels[getMedal].isNew = true
        }
        medalModels[getMedal].count += 1
    }
    
    /// メダル番号取得
    private func getLastMedal() -> Int {
        let medals = ParsistManager.loadMedals()
        var lastMedal = 0
        var beforeMedalCount = medals[0].count
        for i in 1..<medals.count {
            if beforeMedalCount > medals[i].count {
                lastMedal = i
            }
            beforeMedalCount = medals[i].count
        }
        return lastMedal
    }
}

// MARK: - CVCalendarViewAppearanceDelegate

extension MainViewController: CVCalendarViewAppearanceDelegate {
    
    // MARK: Optional methods
    // Rendering options.
    func spaceBetweenWeekViews() -> CGFloat {
        return 0
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 0
    }

    // Font options.
    func dayLabelWeekdayFont() -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIFont.systemFont(ofSize: 50)
        }
        return UIFont.systemFont(ofSize: 20)
    }
    
    // Text color.
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        return .black
    }
}

// MARK: - CVCalendarViewDelegate

extension MainViewController: CVCalendarViewDelegate {
    
    // MARK: Required methods
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    // MARK: Optional methods
    /*
     Determines whether resizing should cause related views' animation.
     */
    func shouldScrollOnOutDayViewSelection() -> Bool {
        return false
    }
    
    func shouldSelectDayView(_ dayView: DayView) -> Bool {
        return false
    }

    func shouldAutoSelectDayOnWeekChange() -> Bool {
        return false
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }

    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRect(x: 0, y: 0, width: $0.width, height: $0.height)) }
    }
    
    func shouldShowCustomSingleSelection() -> Bool {
        return false
    }

    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        // 丸をつけた日は日付を表示しません
        let model = ParsistManager.load(date: dayView.date.convertedDate()!)
        if model.isAchieveHomeWork || model.isAchieveStudy {
            dayView.dayLabel.isHidden = true
        }

        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    // 日付に丸を付ける
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        // 丸をつけた日は日付を表示しません
        dayView.dayLabel.isHidden = true

        let width = dayView.frame.size.width
        let height = dayView.frame.size.height

        let model = ParsistManager.load(date: dayView.date.convertedDate()!)
        let hanamaruView = UIImageView(image: UIImage(named: "hanamaru"))
        hanamaruView.frame.size = CGSize(width: width, height: height)
        hanamaruView.contentMode = UIViewContentMode.scaleAspectFit
        dayView.addSubview(hanamaruView)
        if model.isAchieveHomeWork && model.isAchieveStudy {
            let image = UIImage(named: String(format: "sano%04d", model.medal + 1))
            let sanoView = UIImageView(image: image)
            sanoView.frame.size = CGSize(width: width, height: height)
            sanoView.contentMode = UIViewContentMode.scaleAspectFit
            dayView.addSubview(sanoView)
        }
        return dayView
    }
    
    // 日毎に丸を付けるかどうか判定
    // 前後数ヶ月も呼ばれるのでめんどくさ・・注意！
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        let model = ParsistManager.load(date: dayView.date.convertedDate()!)
        if model.isAchieveHomeWork || model.isAchieveStudy {
            return true
        }
        return false
    }
    
    // Localization
    func calendar() -> Calendar? { return currentCalendar }
    
    // Range selection
    func shouldSelectRange() -> Bool {
        return false
    }
    
    func didSelectRange(from startDayView: DayView, to endDayView: DayView) {
    }
    
    func disableScrollingBeforeDate() -> Date {
        return Date()
    }
    
    func maxSelectableRange() -> Int {
        return 0
    }
    
    func earliestSelectableDate() -> Date {
        return Date()
    }
    
    func latestSelectableDate() -> Date {
        return Date()
    }
}

// MARK: - CVCalendarMenuViewDelegate
extension MainViewController: CVCalendarMenuViewDelegate {
    
    // MARK: Optional methods
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return weekday == .sunday ? UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0) : UIColor.black
    }
    
    // 曜日の背景色
//    func dayOfWeekBackGroundColor() -> UIColor {
//        return .lightGray
//    }
    
//    func dayOfWeekTextColor() -> UIColor {
//        return .white
//    }
    
    // 曜日のフォントサイズ
    func dayOfWeekFont() -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIFont.systemFont(ofSize: 40)
        }
        return UIFont.systemFont(ofSize: 18)
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .short
    }
}
