//
//  BusApproachModel.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/31.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation
import RxSwift
import Result
import APIKit

enum BusApproachModelState {
    case notFetchingYet
    case fetching
    case fetched(Result<[BusLocation], APIError>)
}

enum APIError: Error {
    case error(String)
    case unknown(String)
}

protocol BusApproachModelContract {
    var didChange: Observable<BusApproachModelState> { get }
    var stateVariable: Variable<BusApproachModelState> { get }
}

class BusApproachModel: BusApproachModelContract {
    var didChange: Observable<BusApproachModelState>

    private(set) var stateVariable =  Variable<BusApproachModelState>(.notFetchingYet)

    private let disposeBag: DisposeBag

    init(disposeBag: DisposeBag) {
        self.didChange = self.stateVariable.asObservable()
        self.disposeBag = disposeBag
    }

    func fetch(from: String, to: String) {
        switch self.stateVariable.value {
        case .fetching:
            return
        case .notFetchingYet, .fetched:
            self.transit(to: .fetching)
            self.fetchImpl(from: from, to: to)
        }
    }

    private func fetchImpl(from: String, to: String) {
        let checkSignpoleRequest = Session.rx_response(request: CheckSignpoleRequest(from: from, to: to)).single()
        let getBusApproachRequest = Session.rx_response(request: GetBusApproachRequest(from: from, to: to)).single()
        Observable.zip(checkSignpoleRequest, getBusApproachRequest)
            .subscribe(onNext: { [weak self] (checkSignpole, busLocation) in
                guard let `self` = self else {
                    return
                }
                if checkSignpole.successStatus {
                    self.transit(to: .fetched(.success(busLocation)))
                } else {
                    if let message = checkSignpole.errors.first?.errorMessage {
                        self.transit(to: .fetched(.failure(.error(message))))
                    } else {
                        self.transit(to: .fetched(.failure(.unknown("エラー"))))
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    private func transit(to nextState: BusApproachModelState) {
        self.stateVariable.value = nextState
    }
}
