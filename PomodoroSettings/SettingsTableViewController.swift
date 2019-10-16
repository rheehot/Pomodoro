//
//  SettingsTableViewController.swift
//  Pomodoro
//
//  Created by 류성두 on 29/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import MessageUI
import PomodoroFoundation
import JiraSupport
import UIKit

public class SettingsTableViewController: UITableViewController {
    @IBOutlet var amountSettingCells: [AmountSettingCell]!
    @IBOutlet var toggleSettingCells: [ToggleSettingCell]!
    @IBOutlet var contactCell: UITableViewCell!

    public override func viewDidLoad() {
        super.viewDidLoad()
        amountSettingCells.forEach({ [weak self] in self?.update($0) })
        toggleSettingCells.forEach({ [weak self] in self?.setUp($0) })
        if MFMailComposeViewController.canSendMail() == false {
            contactCell.isHidden = true
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? PickerUpdater,
            let cellToUpdate = sender as? AmountSettingCell {
            nextVC.settingCell = cellToUpdate
            nextVC.pickerTitle = cellToUpdate.titleLabel?.text
        }
    }

    public override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    public override func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func update(_ cell: AmountSettingCell) {
        var amount = retreiveAmount(for: cell.content, from: UserDefaults(suiteName: "group.pomodoro.com")!)
        if amount == 0, let defaultValue = cell.content.defaultValue as? Int {
            amount = defaultValue
        }
        guard let valueToUpdate = amount else { return }
        cell.update(for: valueToUpdate)
    }

    func setUp(_ cell: ToggleSettingCell) {
        var savedBool = retreiveBool(for: cell.content, from: UserDefaults(suiteName: "group.pomodoro.com")!)
        if savedBool == nil {
            savedBool = cell.content.defaultValue as? Bool
        }
        guard let boolToSetUp = savedBool else { return }
        cell.setUp(for: boolToSetUp)
    }

    @IBAction func contactCellClicked(_: Any?) {
        guard let mailComposer = mailComposeViewController else { return }
        mailComposer.mailComposeDelegate = self
        present(mailComposer, animated: true, completion: nil)
    }
    
    @IBAction func JiraLoginClicked() {
        var vc: UIViewController? = nil
        if let _ = try? retreiveSavedCredentials() {
            vc = JiraLogOutViewController(nibName: JiraLogOutViewController.className,
                                          bundle: Bundle(for: JiraLogOutViewController.self))
        }
        else {
            vc = JiraLoginViewController(nibName: JiraLoginViewController.className,
                                         bundle: Bundle(for: JiraLoginViewController.self))
        }
        show(vc!, sender: nil)
    }

    var mailComposeViewController: MFMailComposeViewController? {
        guard MFMailComposeViewController.canSendMail() else {
            return nil
        }
        let composeViewController = MFMailComposeViewController()
        composeViewController.setToRecipients(["dev.esung@gmail.com"])
        composeViewController.setSubject("Feedback From Pomodoro User")
        composeViewController.setMessageBody("Device Version: \(UIDevice.current.systemVersion)", isHTML: false)
        return composeViewController
    }

    @IBAction func devModeToggled(_: UISwitch) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            self?.amountSettingCells.forEach({ [weak self] in self?.update($0) })
        })
    }
}

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith _: MFMailComposeResult, error _: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
