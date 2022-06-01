//
//  ViewController.swift
//  Banner-Bank
//

import UIKit
import FlybitsConcierge
import FlybitsCoreConcierge

class ViewController: UITableViewController {

    private lazy var bannerConcierge: UIViewController = {
        let customViewables = ["concierge-card-buttons": AnyViewable(viewable: CustomButtonsCardViewable())]

        let result = Concierge.viewController(.expose, params: [], options: [.style(.banner), .customViewables(customViewables)])
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Banner Bank ABC"

        tableView.register(BannerContainerCell.self, forCellReuseIdentifier: BannerContainerCell.identifier)
        addChild(bannerConcierge)
        bannerConcierge.didMove(toParent: self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Offers"
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
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
            let newCell = tableView.dequeueReusableCell(withIdentifier: BannerContainerCell.identifier)
            guard let containerCell = newCell as? BannerContainerCell else {
                return UITableViewCell()
            }

            // Attach the Expose Concierge into the custom cell
            containerCell.installConcierge(viewController: bannerConcierge)

            return containerCell
        case 1:
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
        case 0:
            return 200
        default:
            return 44
        }
    }
}

/// Custom Cell to host Banner Concierge.
class BannerContainerCell: UITableViewCell {

    static let identifier = "BannerContainerCell"

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


class CustomButtonsCardViewable: ButtonBannerConciergeViewable {

   override var tileViewControllerLayout: URL? {
        guard let filePath = Bundle.main.path(forResource: "CustomButtonBanner", ofType: "json") else {
            return nil
        }
        return URL(fileURLWithPath: filePath)
    }
}
