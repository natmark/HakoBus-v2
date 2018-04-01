//
//  SearchViewModel.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/30.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation
import APIKit
import RxSwift
import RxCocoa

protocol SearchViewModelInputs {
    var select: PublishSubject<IndexPath> { get }
    var `switch`: PublishSubject<Void> { get }
    var busStops: PublishSubject<[BusStop]> { get }
    var selectedCategory: PublishSubject<InputBusStopCategory> { get }
    var searchText: PublishSubject<String> { get }
}

protocol SearchViewModelOutputs {
    var searchResult: Variable<[BusStop]> { get }
    var category: Variable<InputBusStopCategory> { get }
    var from: Variable<BusStop?> { get }
    var to: Variable<BusStop?> { get }
}

protocol SearchViewModelType {
    var inputs: SearchViewModelInputs { get }
    var outputs: SearchViewModelOutputs { get }
}

enum InputBusStopCategory {
    case departure
    case destination
}

final class SearchViewModel: SearchViewModelType, SearchViewModelInputs, SearchViewModelOutputs {
    var inputs: SearchViewModelInputs { return self }
    private(set) var select = PublishSubject<IndexPath>()
    private(set) var `switch` = PublishSubject<Void>()
    private(set) var busStops = PublishSubject<[BusStop]>()
    private(set) var selectedCategory = PublishSubject<InputBusStopCategory>()
    private(set) var searchText = PublishSubject<String>()

    var outputs: SearchViewModelOutputs { return self }
    private(set) var searchResult = Variable<[BusStop]>([])
    private(set) var from = Variable<BusStop?>(nil)
    private(set) var to = Variable<BusStop?>(nil)
    private(set) var category = Variable<InputBusStopCategory>(.departure)

    private let disposeBag: DisposeBag
    private let _busStops = Variable<[BusStop]>([])
    private let _searchText = Variable<String>("")

    private var bindBusStops: AnyObserver<[BusStop]> {
        return Binder(self) { me, busStops in
            me._busStops.value = busStops
            me.searchResult.value = busStops
            }.asObserver()
    }

    private var filteringBusStops: AnyObserver<String> {
        return Binder(self) { me, text in
            if text != "" {
                me.searchResult.value = me._busStops.value.filter { $0.name.contains(text)}
            } else {
                me.searchResult.value = me._busStops.value
            }
        }.asObserver()
    }

    private var selectBusStop: AnyObserver<IndexPath> {
        return Binder(self) { me, indexPath in
            switch me.category.value {
            case .departure:
                me.from.value = me.searchResult.value[indexPath.row]
            case .destination:
                me.to.value = me.searchResult.value[indexPath.row]
            }
            }.asObserver()
    }

    private var switchBusStop: AnyObserver<Void> {
        return Binder(self) { me, _  in
            swap(&me.from.value, &me.to.value)
            }.asObserver()
    }

    init(disposeBag: DisposeBag) {
        self.disposeBag = disposeBag

        searchText.asObservable()
            .bind(to: filteringBusStops)
            .disposed(by: disposeBag)

        select.asObserver()
            .bind(to: selectBusStop)
            .disposed(by: disposeBag)

        `switch`.asObservable()
            .bind(to: switchBusStop)
            .disposed(by: disposeBag)

        busStops.asObservable()
            .bind(to: bindBusStops)
            .disposed(by: disposeBag)

        searchText.asObservable()
            .bind(to: _searchText)
            .disposed(by: disposeBag)

        selectedCategory.asObservable()
            .bind(to: category)
            .disposed(by: disposeBag)

        Session.rx_response(request: GetBusStopsRequest(searchText: "")).single()
            .bind(to: busStops)
            .disposed(by: disposeBag)

    }
}
