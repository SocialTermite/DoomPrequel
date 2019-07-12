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

class RoverSelectionVC : DPViewController {
    private let viewModel: RoverSelectionVM

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
        setupTableViewSource()
    }

    private func setupUI() {
        view.addSubview(selectLabel)
        selectLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(100)
            maker.centerX.equalToSuperview()
            maker.left.greaterThanOrEqualTo(15)
            maker.right.lessThanOrEqualTo(15)
            maker.height.equalTo(60)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(selectLabel.snp.bottom).offset(100)
            maker.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupTableViewSource() {
        
        tableView.register(UINib(nibName: "RoverCell", bundle: nil), forCellReuseIdentifier: "RoverCell")
        
        viewModel
            .rovers
            .bind(to: tableView.rx.items(cellIdentifier: "RoverCell", cellType: RoverCell.self)) { row, element, cell in
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
    }
    
    private var selectLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "NotoSerif", size: 22)
        label.numberOfLines = 0
        label.text = "Select Rover,\n to start exploring mars photos"
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
