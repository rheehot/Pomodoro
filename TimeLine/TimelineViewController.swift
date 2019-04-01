//
//  ViewController.swift
//  TimeLine
//
//  Created by 류성두 on 11/02/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import PomodoroFoundation
import PomodoroUIKit
import UIKit

open class TimelineViewController: UIViewController {
    @IBOutlet public var titleTextView: UITextView!
    @IBOutlet public var tableView: UITableView!
    public var fetchedHistories: [HistoryMO] = []

    open override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        titleTextView.text = ""
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        let cellNib = UINib(nibName: TimeLineCell.className, bundle: Bundle(for: TimeLineCell.self))
        tableView.register(cellNib, forCellReuseIdentifier: TimeLineCell.className)
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editVC = segue.destination as? EditorViewController, let sender = sender as? TimeLineCell {
            editVC.delegate = sender
            editVC.history = sender.history
        }
    }
}

extension TimelineViewController: UITableViewDataSource {
    open func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return fetchedHistories.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeLineCell.className) as! TimeLineCell
        let isLastIndex = (indexPath.row == fetchedHistories.count - 1)
        let history = fetchedHistories[indexPath.row]
        cell.update(with: history, isLast: isLastIndex)
        return cell
    }

    public func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension TimelineViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TimeLineCell else { return }
        performSegue(withIdentifier: "showEditVC", sender: cell)
    }

    open func tableView(_: UITableView, viewForFooterInSection _: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "progressCell")
        return cell
    }
}
