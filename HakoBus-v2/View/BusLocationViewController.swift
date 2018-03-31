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
    @IBOutlet weak var updateTimeLabelButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var dataSource: BusLocationTableViewDataSource!
    var disposeBag: DisposeBag!
    var viewModel: LocationViewModelType!
    var from: BusStop!
    var to: BusStop!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "検索結果"
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

        reloadButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.viewModel.inputs.reload.onNext(())
            })
            .disposed(by: disposeBag)

        viewModel.outputs.departure.asObservable()
            .map { "乗車 : \($0)"}
            .bind(to: departureLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.destination.asObservable()
            .map { "降車 : \($0)"}
            .bind(to: destinationLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.updatedTime.asObservable()
            .map { date -> String in
                let formatter = DateFormatter()
                formatter.dateFormat = "更新 [HH:mm]"
                return formatter.string(from: date)
            }
            .bind(to: updateTimeLabelButton.rx.title())
            .disposed(by: disposeBag)

        viewModel.outputs.didChange.asObservable()
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
        return 180
    }
}
