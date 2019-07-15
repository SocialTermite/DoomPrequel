//
//  RoverSelectionVC.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 12.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import JGProgressHUD
import Toast_Swift

class RoverSelectionVC : DPViewController {
    private let viewModel: RoverSelectionVM
    private let hud: JGProgressHUD = JGProgressHUD(style: .dark)
    init(viewModel: RoverSelectionVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hud.show(in: tableView)
        setupTableViewSource()
        
    }

    private func setupUI() {
        view.addSubview(selectLabel)
        selectLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(75)
            maker.centerX.equalToSuperview()
            maker.left.greaterThanOrEqualTo(15)
            maker.right.lessThanOrEqualTo(15)
            maker.height.equalTo(60)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(selectLabel.snp.bottom).offset(75)
            maker.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupTableViewSource() {
        
        tableView.register(UINib(nibName: Constants.TableView.CellIdentifier.rover.rawValue, bundle: nil), forCellReuseIdentifier: Constants.TableView.CellIdentifier.rover.rawValue)
        
        let rovers = viewModel
            .roversObservable
            .debug()
            .share()
        
        rovers
            .subscribe(onNext: { [hud] _ in
                hud.dismiss()
            })
            .disposed(by: trash)
            
        rovers
            .bind(to: tableView.rx.items(cellIdentifier: Constants.TableView.CellIdentifier.rover.rawValue, cellType: RoverCell.self)) { row, element, cell in
                cell.setup(with: element)
            }
            .disposed(by: trash)
        
        tableView
            .rx
            .modelSelected(Rover.self)
            .subscribe(onNext: { [weak self] element in
                self?.viewModel.userSelected(element)
            })
            .disposed(by: trash)
        viewModel
            .errorObservable
            .subscribe(onNext: {[weak self] error in
                guard let view = self?.view else {
                    return
                }
                view.makeToast("\(Constants.Text.errorText.localized()) - \(error.localizedDescription)", duration: 3, point: view.center, title: Constants.Text.errorTitle.localized(), image: nil, style: ToastStyle.default(), completion: nil)
            })
            .disposed(by: trash)
    }
    
    private var selectLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.h1.font()
        label.numberOfLines = 0
        label.text = Constants.Text.selectRover.localized()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 60.0
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        return tableView
    }()
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension UIView {
    func addSubview(_ view: UIView, maker: (ConstraintMaker) -> Void) {
        self.addSubview(view)
        self.snp.makeConstraints(maker)
    }
}

extension ToastStyle {
    static func `default`() -> ToastStyle {
        var style = ToastStyle()
        style.titleAlignment = .center
        return style
    }
}
