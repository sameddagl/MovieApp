//
//  FilterViewController.swift
//  MovieAppMVVM
//
//  Created by Samed Dağlı on 1.11.2022.
//

import UIKit
import PanModal
protocol FilterViewDelegate: AnyObject{
    func didSelectCategory(categoryTitle: String, category: DataType)
}

class FilterViewController: UIViewController, PanModalPresentable {
    @IBOutlet weak var tableView: UITableView!
    
    var categories = ["Top Rated", "Popular", "Upcoming"]
    weak var delegate: FilterViewDelegate?
    var panScrollable: UIScrollView?{
        return nil
    }
    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }
    var longFormHeight: PanModalHeight{
        return .contentHeight(300)
    }
    var shouldRoundTopCorners: Bool{
        return true
    }
    var cornerRadius: CGFloat{
        return 10
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension FilterViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.filterCellIdentifier, for: indexPath)
        if #available(iOS 14.0, *) {
            var configurator = cell.defaultContentConfiguration()
            configurator.text = categories[indexPath.row]
            configurator.textProperties.alignment = .center
            cell.contentConfiguration = configurator
        } else {
            cell.textLabel?.text = categories[indexPath.row]
            cell.textLabel?.textAlignment = .center
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300 / CGFloat(categories.count)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedCategory = DataType.topRated
        switch indexPath.row{
            case 0:
                selectedCategory = .topRated
            case 2:
                selectedCategory = .popular
            case 3:
                selectedCategory = .upcoming
            default:
                selectedCategory = .topRated
        }
        self.delegate?.didSelectCategory(categoryTitle: categories[indexPath.row], category: selectedCategory)
        dismiss(animated: true)
    }
}
