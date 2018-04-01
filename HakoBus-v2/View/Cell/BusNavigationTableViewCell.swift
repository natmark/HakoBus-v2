//
//  BusNavigationTableViewCell.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/31.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import UIKit

class BusNavigationTableViewCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var requiredTimeLabel: UILabel!
    @IBOutlet weak var arriveTimeLabel: UILabel!
    @IBOutlet weak var destinationTimeLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        baseView.layer.masksToBounds = false

        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOpacity = 0.4
        baseView.layer.shadowOffset = CGSize(width: 0, height: 5)
        baseView.layer.shadowRadius = 3
    }

    func configure(indexPath: IndexPath, viewModel: LocationViewModel) {
        let location = viewModel.outputs.locations.value[indexPath.row]
        orderLabel.text = "\(indexPath.row + 1)"
        departureLabel.text = viewModel.outputs.departure.value
        destinationLabel.text = viewModel.outputs.destination.value
        titleLabel.text = location.destination
        routeLabel.text = location.route
        departureTimeLabel.text = location.estimatedDepartureTime
        destinationTimeLabel.text = location.estimatedDestinationTime
        arriveTimeLabel.text = location.departureInfo
        requiredTimeLabel.text = location.requiredTime
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
