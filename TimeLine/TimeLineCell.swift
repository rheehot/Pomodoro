//
//  TimeLineCell.swift
//  TimeLine
//
//  Created by 류성두 on 11/03/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Spring
import UIKit

open class TimeLineCell: UITableViewCell {
    public var history: HistoryMO?
    @IBOutlet private var labelTitle: UILabel!
    @IBOutlet private var labelContent: UILabel!
    @IBOutlet private var labelTime: UILabel!
    @IBOutlet private var labels: [UILabel]!
    @IBOutlet var heightOfArrow: NSLayoutConstraint!
    @IBOutlet var viewCard: UIView!
    var heightArrowConstantFromIB: CGFloat!

    var isLastItem = false

    open func update(with history: HistoryMO, isLast: Bool) {
        update(isLastItem: isLast)
        update(with: history)
    }

    func update(isLastItem: Bool) {
        if isLastItem {
            heightOfArrow.constant = CGFloat.leastNonzeroMagnitude
        } else {
            heightOfArrow.constant = heightArrowConstantFromIB
        }
    }

    func update(with history: HistoryMO) {
        isHidden = false
        self.history = history
        labelTitle.text = history.title
        labelContent.text = history.content
        labelTime.text = history.durationStr
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        heightArrowConstantFromIB = heightOfArrow.constant
        selectionStyle = .none
        labels.forEach { $0.text = "" }
        labelContent.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: labelContent.font)
        isHidden = true
//        viewCard.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewCard.layer.shadowRadius = 20
        viewCard.layer.shadowColor = UIColor.black.cgColor
    }
}

extension TimeLineCell: EditorViewControllerDelegate {
    public func itemDidChange(_ title: String, body: String) {
        labelTitle.text = title
        labelContent.text = body
    }
}
