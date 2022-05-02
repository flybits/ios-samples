//
//  MainViewController.swift
//  Expose-Bank
//
//  Created by Caio on 2022-05-02.
//

import UIKit
import Foundation
import FlybitsCoreConcierge
import FlybitsConcierge

class MainViewController: UITableViewController {

    let discoverabilityCell = ExposeCell(style: .default, reuseIdentifier: ExposeCell.identifier)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ExposeCell.self, forCellReuseIdentifier: ExposeCell.identifier)
        addChild(discoverabilityCell.vc)
        discoverabilityCell.vc.didMove(toParent: self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // CAIO
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        switch indexPath.row {
        case 0:
            return discoverabilityCell
        case 1:
            content.text = "Your account has $1,234,567.89"
        case 2:
            content.text = "Be more green"
            content.secondaryText = "Do you want to receive eStatments instead of papers?"
        case 3:
            content.text = "How is the weather today?"
            content.secondaryText = "Today is very hot in your city with 36º C in the forecast."
        case 4:
            content.text = "Test"
            content.secondaryText = "Test"
        default:
            print("Error: This scenario should not happen. Row value: \(indexPath.row)")
        }

        cell.contentConfiguration = content

        return cell
    }
}

class ExposeCell: UITableViewCell {

    static let identifier = "ExposeCell"

    let vc = Concierge.viewController(.expose,
                                      params: [],
                                      options: [.customViewables(["concierge-card-buttons": AnyViewable(viewable: DiscoverableButtonsCardConciergeViewable()),
                                                                  "concierge-card-link": AnyViewable(viewable: DiscoverableLinkCardConciergeViewable())])
                                      ])

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(vc.view)
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            vc.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vc.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        if let resizeVc = vc as? ConciergeAutoResizeViewController {
            resizeVc.addResizedListeners { [weak self] _, _ in
                self?.reload()
            }
        }
    }

    private func reload() {
        if let tableview = superview as? UITableView, let indexPath = tableview.indexPath(for: self) {
            tableview.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        }
    }

    private func initialConstraint() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
