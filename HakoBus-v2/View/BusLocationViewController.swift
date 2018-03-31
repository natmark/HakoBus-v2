//
//  BusLocationViewController.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/31.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import UIKit
import RxSwift

class BusLocationViewController: UIViewController {
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var switchLabel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var dataSource: BusLocationTableViewDataSource!
    var disposeBag: DisposeBag!
    var viewModel: LocationViewModel!
    var from: BusStop!
    var to: BusStop!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.largeTitleDisplayMode = .never
        dataSource.configure(with: tableView)
        tableView.delegate = self

        backButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.departure.asObservable()
            .map { "乗車バス停: \($0)"}
            .bind(to: departureLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.destination.asObservable()
            .map { "降車バス停: \($0)"}
            .bind(to: destinationLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.didChange.asObservable()
            .subscribe(onNext: { [weak self] state in
                guard let `self` = self else {
                    return
                }

                switch state {
                case .notFetchingYet:
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                case .fetching:
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                case .fetched:
                    self.tableView.reloadData()
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)

        viewModel.inputs.from.onNext(from.name)
        viewModel.inputs.to.onNext(to.name)
        viewModel.inputs.reload.onNext(())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BusLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
