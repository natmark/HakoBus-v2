//
//  SearchViewController.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/30.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    @IBOutlet weak var departureButton: UIButton!
    @IBOutlet weak var destinationButton: UIButton!
    @IBOutlet weak var departureLabelButton: UIButton!
    @IBOutlet weak var destinationLabelButton: UIButton!

    var disposeBag: DisposeBag!
    var viewModel: SearchViewModel!
    var inputBusStopViewController: InputBusStopViewController!

    let generateNavigationController = { (rootViewController: UIViewController) -> UINavigationController in
        var navigationController: UINavigationController
        navigationController =  UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = #colorLiteral(red: 0.6321853995, green: 0.07877074927, blue: 0.007939325646, alpha: 1)
        navigationController.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController.navigationBar.titleTextAttributes = textAttributes

        return navigationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Observable.merge(departureButton.rx.tap.asObservable(),
                         departureLabelButton.rx.tap.asObservable())
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.viewModel.selectedCategory.value = .departure
                let navigationController = self.generateNavigationController(self.inputBusStopViewController)
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        Observable.merge(destinationButton.rx.tap.asObservable(),
                         destinationLabelButton.rx.tap.asObservable())
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.viewModel.selectedCategory.value = .destination
                let navigationController = self.generateNavigationController(self.inputBusStopViewController)
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        viewModel.from
            .flatMap { value -> Observable<String> in
                Observable.just(value.name)
            }.bind(to: departureLabelButton.rx.title())
            .disposed(by: disposeBag)

        viewModel.from
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else {
                    return
                }
                self.departureLabelButton.setTitleColor(.black, for: .normal)
            })
            .disposed(by: disposeBag)

        viewModel.to
            .flatMap { value -> Observable<String> in
                Observable.just(value.name)
            }.bind(to: destinationLabelButton.rx.title())
            .disposed(by: disposeBag)

        viewModel.to
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else {
                    return
                }
                self.destinationLabelButton.setTitleColor(.black, for: .normal)
            })
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
