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
import JGProgressHUD

class PhotosVC : DPViewController {
    private let viewModel: PhotosVM

    private let hud = JGProgressHUD(style: .dark)
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
        tableView.register(UINib(nibName: Constants.TableView.CellIdentifier.photo.rawValue, bundle: nil), forCellReuseIdentifier: Constants.TableView.CellIdentifier.photo.rawValue)
        
        viewModel
            .isLoadingObservable
            .subscribe(onNext: {[hud, tableView, emptyResultLabel] isLoading in
                if isLoading {
                    hud.show(in: tableView)
                    emptyResultLabel.isHidden = true
                } else {
                    hud.dismiss()
                }
            })
            .disposed(by: trash)
        let photos = viewModel
            .photosObservable
            .share()
        photos
            .bind(to: tableView.rx.items(cellIdentifier: Constants.TableView.CellIdentifier.photo.rawValue, cellType: PhotoCell.self)) {[weak self] row, photo, cell in
                cell.setup(with: photo)
                cell.isDownloaded = {
                    //self?.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
                }
                self?.viewModel.rowPresented(row)
                self?.showFullscreenByTap(in: cell)
                
            }
            .disposed(by: trash)
        
        photos
            .map { !$0.isEmpty }
            .bind(to: emptyResultLabel.rx.isHidden)
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
        view.addSubview(emptyResultLabel)
        emptyResultLabel.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        
        let pickersView = DPPickersView(cameras: viewModel.cameras, minimumDate: viewModel.landingDate, maximumDate: viewModel.maxDate, selectedCamera: viewModel.selectedCamera, selectedDate: viewModel.selectedDate)
        
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
        
        tableView
            .rx
            .didScroll
            .map { pickersView.isPresenting() }
            .filter { $0 }
            .subscribe(onNext: { _ in pickersView.dissmiss() })
            .disposed(by: trash)
        
        view.addSubview(pickersView)
        
        pickersView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            maker.leading.trailing.equalToSuperview()
        }
    }
    
    private var emptyResultLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Constants.Text.emptyResult.localized()
        label.font = Constants.Font.h2.font()
        label.textColor = .white
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private func setupNavBar() {
        navigationController?.navigationBar.installBlurEffect()
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Constants.Text.rover.localized(), style: .plain, target: self, action: #selector(roverButtonTapped))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([.font: Constants.Font.h2.font()], for: .normal)
        navigationItem.title = viewModel.roverName
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,
                                                            NSAttributedString.Key.font: Constants.Font.h1.font()]
    }
    
    @objc private func roverButtonTapped() {
        viewModel.backToRoverSelection()
    }
}
