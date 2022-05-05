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

    private lazy var exposeConciergeViewController: UIViewController = {
        let result = Concierge.viewController(.expose, params: [], options: [])
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Bank ABC"

        tableView.register(ConciergeContainerCell.self, forCellReuseIdentifier: ConciergeContainerCell.identifier)

        addChild(exposeConciergeViewController)
        exposeConciergeViewController.didMove(toParent: self)
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
                        cell.textLabel?.text = "Touch here to Connect"

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
                        cell.textLabel?.text = "Touch here to Disconnect"

                        tableView.deselectRow(at: indexPath, animated: true)
                    }
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
            cell.textLabel?.text = "Chequing"
            cell.detailTextLabel?.text = "$200.00"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
            cell.textLabel?.text = "Savings"
            cell.detailTextLabel?.text = "$12.00"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
            cell.textLabel?.text = "Credit"
            cell.detailTextLabel?.text = "$12,000.00"
            return cell
        case 3:
            // Get the ConciergeContainerCell from tableView
            let newCell = tableView.dequeueReusableCell(withIdentifier: ConciergeContainerCell.identifier)
            guard let containerCell = newCell as? ConciergeContainerCell else {
                return UITableViewCell()
            }

            // Attach the Expose Concierge into the custom cell
            containerCell.installConcierge(viewController: exposeConciergeViewController)

            return containerCell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
            if Concierge.isConnected {
                cell.textLabel?.text = "Touch here to Disconnect"
            } else {
                cell.textLabel?.text = "Touch here to Connect"
            }

            cell.detailTextLabel?.text = ""
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
            print("Error: This scenario should not happen. Row value: \(indexPath.row)")
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 3:
            return 412
        default:
            return 44
        }
    }
}

// MARK: - Support Classes

/// Custom Cell to host the Expose Concierge.
class ConciergeContainerCell: UITableViewCell {

    static let identifier = "ConciergeContainerCell"

    weak var conciergeViewController: UIViewController?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    func installConcierge(viewController: UIViewController) {
        if conciergeViewController == viewController, viewController.view.superview == contentView {
            return
        }
        conciergeViewController = viewController
        viewController.view.removeFromSuperview()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewController.view)
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        if let conciergeViewController = conciergeViewController,
           conciergeViewController.view.superview == contentView {
            conciergeViewController.view.removeFromSuperview()
            conciergeViewController.removeFromParent()
        }
        conciergeViewController = nil
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
