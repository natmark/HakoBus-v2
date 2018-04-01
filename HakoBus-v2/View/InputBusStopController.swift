//
//  InputBusStopViewController.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/30.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import UIKit
import Swinject
import RxSwift
import RxCocoa

class InputBusStopViewController: UIViewController, UISearchResultsUpdating {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stopBarButtonItem: UIBarButtonItem!

    var dataSource: InputBusStopTableViewDataSource!
    var disposeBag: DisposeBag!
    var viewModel: SearchViewModelType!

    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.definesPresentationContext = true
        return searchController
    }()

    private var changeSearchBarPlaceHolder: AnyObserver<InputBusStopCategory> {
        return Binder(self) { me, category in
            switch category {
            case .departure:
                me.searchController.searchBar.placeholder = "出発地を入力"
            case .destination:
                me.searchController.searchBar.placeholder = "到着地を入力"
            }
        }.asObserver()
    }

    private var reloadData: AnyObserver<[BusStop]> {
        return Binder(self) { me, _ in
            me.tableView.reloadData()
            }.asObserver()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        navigationItem.titleView = searchController.searchBar
        dataSource.configure(with: tableView)
        tableView.delegate = self

        viewModel.outputs.category.asObservable()
            .bind(to: changeSearchBarPlaceHolder)
            .disposed(by: disposeBag)

        viewModel.outputs.searchResult.asObservable()
            .bind(to: reloadData)
            .disposed(by: disposeBag)

        stopBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    func updateSearchResults(for searchController: UISearchController) {
        viewModel.inputs.searchText.onNext(searchController.searchBar.text ?? "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension InputBusStopViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.inputs.select.onNext(indexPath)
        searchController.isActive = false
        dismiss(animated: true, completion: nil)
    }
}
