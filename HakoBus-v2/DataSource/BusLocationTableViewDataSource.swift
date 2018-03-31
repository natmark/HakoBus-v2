//
//  BusLocationTableViewDataSource.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/31.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation
import UIKit

class BusLocationTableViewDataSource: NSObject {
    fileprivate let cellIdentifier = "BusNavigationTableViewCell"
    public var viewModel: LocationViewModel!

    override init() {}

    func configure(with tableView: UITableView) {
        tableView.dataSource = self
    }
}

extension BusLocationTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.locations.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(BusNavigationTableViewCell.self, for: indexPath)
        let location = viewModel.outputs.locations.value[indexPath.row]

        cell.orderLabel.text = "\(indexPath.row + 1)"
        cell.departureLabel.text = viewModel.outputs.departure.value
        cell.departureTimeLabel.text = location.estimatedDepartureTime
        cell.destinationLabel.text = viewModel.outputs.destination.value
        cell.destinationTimeLabel.text = location.estimatedDestinationTime
        return cell
    }
}
