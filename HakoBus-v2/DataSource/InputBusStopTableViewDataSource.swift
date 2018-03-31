//
//  InputBusStopTableViewDataSource.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/30.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation
import UIKit

class InputBusStopTableViewDataSource: NSObject {
    public var viewModel: SearchViewModelType!

    override init() {}

    func configure(with tableView: UITableView) {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self)
    }
}

extension InputBusStopTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.searchResult.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = viewModel.outputs.searchResult.value[indexPath.row].name
        return cell
    }
}
