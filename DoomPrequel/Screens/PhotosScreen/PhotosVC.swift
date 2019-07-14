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
import SimpleImageViewer


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
    
    private func setupTableViewSource() {
        tableView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellReuseIdentifier: "PhotoCell")
        
        viewModel
            .photosObservable
            .bind(to: tableView.rx.items(cellIdentifier: "PhotoCell", cellType: PhotoCell.self)) {[weak self] row, photo, cell in
                cell.setup(with: photo)
                self?.viewModel.rowPresented(row)
                self?.showFullscreenByTap(in: cell)
                
            }
            .disposed(by: trash)
        
    }
    
    private func showFullscreenByTap(in cell: PhotoCell) {
        cell
            .tabObservable
            .subscribe(onNext: {[weak self] _ in
                let configuration = ImageViewerConfiguration { config in
                    config.imageView = cell.photoImageView
                }
                
                let imageViewerController = ImageViewerController(configuration: configuration)
                
                self?.present(imageViewerController, animated: true)
            })
            .disposed(by: self.trash)
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        let pickersView = DPPickersView(cameras: viewModel.cameras, minimumDate: viewModel.landingDate, maximumDate: viewModel.maxDate, selectedCamera: viewModel.selectedCamera, selectedDate: viewModel.selectedDate)
        pickersView
            .installPicker
            .compactMap { $0 }
            .subscribe(onNext: {[weak self] pickerView in
                self?.view.addSubview(pickerView)
                pickerView.snp.makeConstraints({ (maker) in
                    maker.leading.trailing.bottom.equalToSuperview()
                })
            })
            .disposed(by: trash)
        
        pickersView
            .selectedCameraObservable
            .bind(onNext: {[weak self] camera in
                self?.viewModel.selectedCamera = camera
            })
            .disposed(by: trash)
        
        pickersView
            .selectedDateObservable
            .bind(onNext: {[weak self] date in
                self?.viewModel.selectedDate = date
            })
            .disposed(by: trash)
        view.addSubview(pickersView)
        
        pickersView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            maker.leading.trailing.equalToSuperview()
        }
    }
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 40
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
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
