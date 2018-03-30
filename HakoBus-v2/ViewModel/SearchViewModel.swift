//
//  SearchViewModel.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/30.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    let _selectedIndexPath = PublishSubject<IndexPath>()
    var from: Observable<BusStop> {
        return _from.asObservable()
    }

    var to: Observable<BusStop> {
        return _to.asObservable()
    }

    private let disposeBag: DisposeBag
    private let _busStops: Observable<[BusStop]>
    private(set) var _from = PublishSubject<BusStop>()
    private(set) var _to = PublishSubject<BusStop>()
    private(set) var selectedCategory = Variable<InputBusStopCategory>(.departure)
    private(set) var busStops = Variable<[BusStop]>([])
    private(set) var searchResult = Variable<[BusStop]>([])
    private(set) var searchText = Variable<String>("")

    enum InputBusStopCategory {
        case departure
        case destination
    }

    private var bindBusStops: AnyObserver<[BusStop]> {
        return Binder(self) { me, busStops in
            me.busStops.value = busStops
            }.asObserver()
    }

    private var filteringBusStops: AnyObserver<String> {
        return Binder(self) { me, text in
            if text != "" {
                me.searchResult.value = me.busStops.value.filter { $0.name.contains(text)}
            } else {
                me.searchResult.value = me.busStops.value
            }
        }.asObserver()
    }

    private var selectBusStop: AnyObserver<IndexPath> {
        return Binder(self) { me, indexPath in
            switch me.selectedCategory.value {
            case .departure:
                me._from.onNext(me.searchResult.value[indexPath.row])
            case .destination:
                me._to.onNext(me.searchResult.value[indexPath.row])
            }
            }.asObserver()
    }

    init(_busStops: Observable<[BusStop]>, disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
        self._busStops = _busStops

        searchText.asObservable()
            .bind(to: filteringBusStops)
            .disposed(by: disposeBag)

        _busStops
            .bind(to: bindBusStops)
            .disposed(by: disposeBag)

        _selectedIndexPath.asObservable()
            .bind(to: selectBusStop)
            .disposed(by: disposeBag)
    }
}
