//
//  SwinjectStoryboard.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/31.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Swinject
import SwinjectStoryboard
import RxSwift

extension SwinjectStoryboard {
    @objc class func setup() {
        Container.loggingFunction = nil
        // Models
        defaultContainer.register(DisposeBag.self) { _ in DisposeBag() }
        defaultContainer.register(BusApproachModel.self) { r in
            let disposeBag = r.resolve(DisposeBag.self) ?? DisposeBag()
            return BusApproachModel(disposeBag: disposeBag)
        }
        // DataSources
        defaultContainer.register(InputBusStopTableViewDataSource.self) { r in
            let inputBusStopTableViewDataSource = InputBusStopTableViewDataSource()
            inputBusStopTableViewDataSource.viewModel = r.resolve(SearchViewModel.self)
            return inputBusStopTableViewDataSource
        }
        defaultContainer.register(BusLocationTableViewDataSource.self) { r in
            let busLocationTableViewDataSource = BusLocationTableViewDataSource()
            busLocationTableViewDataSource.viewModel = r.resolve(LocationViewModel.self)
            return busLocationTableViewDataSource
        }

        // ViewModels
        defaultContainer.register(SearchViewModel.self) { r in
            let disposeBag = r.resolve(DisposeBag.self) ?? DisposeBag()
            let searchViewModel = SearchViewModel(disposeBag: disposeBag)

            return searchViewModel
        }.inObjectScope(ObjectScope.container)

        defaultContainer.register(LocationViewModel.self) { r in
            let disposeBag = r.resolve(DisposeBag.self) ?? DisposeBag()
            let busApproachModel = r.resolve(BusApproachModel.self) ?? BusApproachModel(disposeBag: disposeBag)
            let locationViewModel = LocationViewModel(busApproachModel: busApproachModel, disposeBag: disposeBag)
            return locationViewModel
        }

        // ViewControllers
        defaultContainer.storyboardInitCompleted(SearchViewController.self) { r, c in
            c.disposeBag = r.resolve(DisposeBag.self)
            c.viewModel = r.resolve(SearchViewModel.self)
        }
        defaultContainer.storyboardInitCompleted(InputBusStopViewController.self) { r, c in
            c.disposeBag = r.resolve(DisposeBag.self)
            c.viewModel = r.resolve(SearchViewModel.self)
            c.dataSource = r.resolve(InputBusStopTableViewDataSource.self)
        }
        defaultContainer.storyboardInitCompleted(BusLocationViewController.self) { r, c in
            c.disposeBag = r.resolve(DisposeBag.self)
            c.viewModel = r.resolve(LocationViewModel.self)
            c.dataSource = r.resolve(BusLocationTableViewDataSource.self)
        }
    }
}
