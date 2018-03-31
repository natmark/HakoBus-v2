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
import SwinjectStoryboard

class SearchViewController: UIViewController {
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var departureButton: UIButton!
    @IBOutlet weak var destinationButton: UIButton!
    @IBOutlet weak var departureLabelButton: UIButton!
    @IBOutlet weak var destinationLabelButton: UIButton!
    @IBOutlet weak var switchBusStopButton: UIButton!

    var disposeBag: DisposeBag!
    var viewModel: SearchViewModelType!

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

    let generateAlertViewController = { (message: String) -> UIAlertController in
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancelAction)

        return alert
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .always

        switchBusStopButton.rx.tap.asObservable()
            .bind(to: viewModel.inputs.switch)
            .disposed(by: disposeBag)

        searchButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else {
                    return
                }

                guard let from = self.viewModel.outputs.from.value else {
                    self.present(self.generateAlertViewController("乗車バス停を入力してください"), animated: true, completion: nil)
                    return
                }

                guard let to = self.viewModel.outputs.to.value else {
                    self.present(self.generateAlertViewController("降車バス停を入力してください"), animated: true, completion: nil)
                    return
                }

                if from.stopcode == to.stopcode {
                    self.present(self.generateAlertViewController("乗車バス停と降車バス停が同じです"), animated: true, completion: nil)
                } else {
                    let viewController = BusLocationViewController.create()
                    viewController.from = from
                    viewController.to = to
                    self.navigationController?.pushViewController(viewController, animated: true)
                }

            })
            .disposed(by: disposeBag)

        Observable.merge(departureButton.rx.tap.asObservable(),
                         departureLabelButton.rx.tap.asObservable())
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.viewModel.inputs.selectedCategory.onNext(.departure)
                let viewController = InputBusStopViewController.create()
                let navigationController = self.generateNavigationController(viewController)
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        Observable.merge(destinationButton.rx.tap.asObservable(),
                         destinationLabelButton.rx.tap.asObservable())
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.viewModel.inputs.selectedCategory.onNext(.destination)
                let viewController = InputBusStopViewController.create()
                let navigationController = self.generateNavigationController(viewController)
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.from.asObservable()
            .subscribe(onNext: { [weak self] busStop in
                guard let `self` = self else {
                    return
                }
                if busStop != nil {
                    self.departureLabelButton.setTitleColor(.black, for: .normal)
                    self.departureLabelButton.setTitle(busStop?.name, for: .normal)
                } else {
                    self.departureLabelButton.setTitleColor(.lightGray, for: .normal)
                    self.departureLabelButton.setTitle("タップして入力", for: .normal)
                }
            })
            .disposed(by: disposeBag)

        viewModel.outputs.to.asObservable()
            .subscribe(onNext: { [weak self] busStop in
                guard let `self` = self else {
                    return
                }
                if busStop != nil {
                    self.destinationLabelButton.setTitleColor(.black, for: .normal)
                    self.destinationLabelButton.setTitle(busStop?.name, for: .normal)
                } else {
                    self.destinationLabelButton.setTitleColor(.lightGray, for: .normal)
                    self.destinationLabelButton.setTitle("タップして入力", for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
