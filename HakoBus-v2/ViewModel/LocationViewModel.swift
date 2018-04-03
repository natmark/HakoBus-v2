//
//  LocationViewModel.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/31.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import APIKit

protocol LocationViewModelInputs {
    var reload: PublishSubject<Void> { get }
    var from: PublishSubject<String> { get }
    var to: PublishSubject<String> { get }
}

protocol LocationViewModelOutputs {
    var updatedTime: Variable<Date> { get }
    var locations: Variable<[BusLocation]> { get }
    var destination: Variable<String> { get }
    var departure: Variable<String> { get }
    var didChange: Variable<BusApproachModelState> { get }
    var error: Variable<APIError> { get }
}

protocol LocationViewModelType {    var reload: PublishSubject<Void> { get }
    var inputs: LocationViewModelInputs { get }
    var outputs: LocationViewModelOutputs { get }
}

final class LocationViewModel: LocationViewModelType, LocationViewModelInputs, LocationViewModelOutputs {
    var inputs: LocationViewModelInputs { return self }
    private(set) var reload = PublishSubject<Void>()
    private(set) var from = PublishSubject<String>()
    private(set) var to = PublishSubject<String>()

    var outputs: LocationViewModelOutputs { return self }
    private(set) var locations =  Variable<[BusLocation]>([])
    private(set) var destination = Variable<String>("")
    private(set) var departure = Variable<String>("")
    private(set) var didChange = Variable<BusApproachModelState>(.notFetchingYet)
    private(set) var error = Variable<APIError>(.unknown(""))
    private(set) var updatedTime = Variable<Date>(Date())

    private let disposeBag: DisposeBag
    private let busApproachModel: BusApproachModel

    init(busApproachModel: BusApproachModel, disposeBag: DisposeBag) {
        self.busApproachModel = busApproachModel
        self.disposeBag = disposeBag

        busApproachModel.didChange
            .subscribe(onNext: { [weak self] status in
                guard let `self` = self else {
                    return
                }
                switch status {
                case .fetched(let result):
                    switch result {
                    case .success(let locations):
                        self.locations.value = locations
                        self.updatedTime.value = Date()
                    case .failure(let error):
                        self.error.value = error
                        self.updatedTime.value = Date()
                    }
                default:
                        break
                }
            })
            .disposed(by: disposeBag)

        busApproachModel.didChange
            .bind(to: didChange)
            .disposed(by: disposeBag)

        Observable.combineLatest(from, to, reload)
            .subscribe(onNext: { [weak self] from, to, _ in
                guard let `self` = self else {
                    return
                }
                self.departure.value = from
                self.destination.value = to

                busApproachModel.fetch(from: from, to: to)
            })
            .disposed(by: disposeBag)
    }
}
