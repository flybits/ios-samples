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

        self.title = "Bank ABC"

        tableView.register(ExposeCell.self, forCellReuseIdentifier: ExposeCell.identifier)
        addChild(discoverabilityCell.vc)
        discoverabilityCell.vc.didMove(toParent: self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Accounts"
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            if Concierge.isConnected {
                Concierge.disconnect { error in
                    guard error == nil else {
                        print("Error: \(error!.localizedDescription)")
                        return
                    }

                    print("Flybits disconnect succeed.")

                    DispatchQueue.main.async {
                        guard let cell = tableView.cellForRow(at: indexPath) else { return }
                        var content = cell.defaultContentConfiguration()
                        content.text = "Touch here to Connect"
                        cell.contentConfiguration = content

                        tableView.deselectRow(at: indexPath, animated: true)
                    }
                }
            } else {
                Concierge.connect(with: AnonymousConciergeIDP()) { error in
                    guard error == nil else {
                        print("Error: failed to connect due to \(error!.localizedDescription)")
                        return
                    }

                    print("Flybits connection succeed.")
                    DispatchQueue.main.async {
                        guard let cell = tableView.cellForRow(at: indexPath) else { return }
                        var content = cell.defaultContentConfiguration()
                        content.text = "Touch here to Disconnect"
                        cell.contentConfiguration = content

                        tableView.deselectRow(at: indexPath, animated: true)
                    }
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        switch indexPath.row {
        case 0:
            content.text = "Chequing"
            content.secondaryText = "$200.00"
        case 1:
            content.text = "Savings"
            content.secondaryText = "$12.00"
        case 2:
            content.text = "Credit"
            content.secondaryText = "$12,000.00"
        case 3:
            return discoverabilityCell
        case 4:
            if Concierge.isConnected {
                content.text = "Touch here to Disconnect"
            } else {
                content.text = "Touch here to Connect"
            }
        default:
            print("Error: This scenario should not happen. Row value: \(indexPath.row)")
        }

        cell.contentConfiguration = content

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
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
