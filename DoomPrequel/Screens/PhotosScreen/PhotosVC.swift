//
//  PhotosVC.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 12.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PhotosVC : DPViewController {
    private let viewModel: PhotosVM

    init(viewModel: PhotosVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupUI()
        setupTableViewSource()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 90.0
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    private func setupNavBar() {
        navigationController?.navigationBar.installBlurEffect()
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Rover", style: .plain, target: self, action: #selector(roverButtonTapped))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "NotoSerif", size: 16)!], for: .normal)
        navigationItem.title = viewModel.roverName
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,
                                                            NSAttributedString.Key.font: UIFont(name: "NotoSerif", size: 22)!]
    }
    
    @objc private func roverButtonTapped() {
        viewModel.backToRoverSelection()
    }
}
