//
//  ViewController.swift
//  Pomodoro
//
//  Created by 류성두 on 22/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import HGCircularSlider
import PomodoroFoundation

public class TimerViewController: UIViewController {
    
    @IBOutlet var mainSlider: CircularSlider!
    @IBOutlet var labelTime: UILabel!
    @IBOutlet var playOrPauseButton: UIButton!
    
    var interval: Interval!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        interval = FocusInterval(intervalDelegate: self)
        interval.setUpNotification(notiDelegate: self)
        setUpInitialView()
    }
    
    func setUpInitialView(){
        mainSlider.endPointValue = 0
        mainSlider.isUserInteractionEnabled = false
        updateMainSlider(with: interval)
        
        let currentFontSize = labelTime.font.pointSize
        labelTime.font = UIFont.monospacedDigitSystemFont(ofSize: currentFontSize, weight: .medium)
        updateLabelTime(with: 0)
        
        playOrPauseButton.setTitle("▶", for: .normal)
    }
    
    func updateMainSlider(with interval:Interval) {
        mainSlider.maximumValue = CGFloat(interval.targetSeconds)
        mainSlider.trackColor = interval.themeColor
        mainSlider.trackFillColor = interval.themeColor
    }
    
    @IBAction func playOrPauseButtonClicked(_ sender: UIButton) {
        if sender.title(for: .normal) == "▶" {
            sender.setTitle("||", for: .normal)
            interval.startTimer()
        }
        else {
            interval.pauseTimer()
            sender.setTitle("▶", for: .normal)
        }
    }
}

extension TimerViewController: IntervalDelegate {
    public func intervalFinished(by finisher: IntervalFinisher) {
        if interval is FocusInterval {
            interval = BreakInterval(intervalDelegate: self)
        }
        else {
            interval = FocusInterval(intervalDelegate: self)
        }
        interval.setUpNotification(notiDelegate: self)
        setUpInitialView()
    }
    
    public func timeElapsed(_ seconds: TimeInterval) {
        updateLabelTime(with: seconds)
        updateMainSlider(to: seconds)
    }
}

extension TimerViewController {
    func updateMainSlider(to time: TimeInterval) {
        let point = CGFloat(time)
        mainSlider.endPointValue = point
        mainSlider.layoutIfNeeded()
    }
    
    func updateLabelTime(with seconds:TimeInterval) {
        guard seconds <= interval.targetSeconds else { return }
        let date = Date(timeIntervalSince1970: interval.targetSeconds - seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("mm:ss")
        labelTime.text = dateFormatter.string(from: date)
    }
}

extension TimerViewController: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.actionIdentifier)
        completionHandler()
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        intervalFinished(by: .time)
        completionHandler([.alert, .sound, .badge])
    }
}
