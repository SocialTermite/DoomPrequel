//
//  PDPickersView.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 12.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class DPPickersView : UIView {
    private let trash = DisposeBag()
    
    private var cameras: [Camera]
    private var minimumDate: Date
    private var maximumDate: Date
    private var selectedCamera: BehaviorRelay<Camera>
    private var selectedDate: BehaviorRelay<Date>
    
    var selectedCameraObservable: Observable<Camera> {
        return selectedCamera.asObservable()
    }
    
    var selectedDateObservable: Observable<Date> {
        return selectedDate.asObservable()
    }
    
    private var cameraButton: UIButton!
    private var dateButton: UIButton!
    private var cameraPicker: UIPickerView!
    private var datePicker: UIDatePicker!
    
    var installPicker: BehaviorRelay<UIView?> = .init(value: nil)
    
    init(cameras: [Camera], minimumDate: Date, maximumDate: Date, selectedCamera: Camera, selectedDate: Date) {
        self.cameras = cameras
        self.selectedCamera = .init(value: selectedCamera)
        self.selectedDate = .init(value: selectedDate)
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupUI() {
        installBlur()
        installMainStackView()
        cameraButton = installPickerButton(with: UIImage(named: "whiteCamera")!,
                                           title: selectedCamera.value.fullName,
                                           trailing: 0)
        dateButton = installPickerButton(with:  UIImage(named: "calendar")!,
                                         title: selectedDate.value.string(),
                                         leading: 0)
        
        cameraPicker = setupCameraPicker()
        datePicker = setupDatePicker()
        
        cameraButton
            .rx
            .tap
            .subscribe(onNext: {[weak self] element in
                if self?.cameraPicker.superview == nil {
                    self?.datePicker.removeFromSuperview()
                    self?.installPicker.accept(self?.cameraPicker)
                } else {
                    self?.cameraPicker.removeFromSuperview()
                    
                }
            })
            .disposed(by: trash)
        
        dateButton
            .rx
            .tap
            .subscribe(onNext: {[weak self] element in
                if self?.datePicker.superview == nil {
                    self?.cameraPicker.removeFromSuperview()
                    self?.installPicker.accept(self?.datePicker)
                } else {
                    self?.datePicker.removeFromSuperview()
                }
            })
            .disposed(by: trash)
        
    }
    
    private func setupCameraPicker() -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .gray
        Observable
            .just(cameras)
            .bind(to: pickerView.rx.itemAttributedTitles) { _, item in
                return NSAttributedString(string: "\(item.fullName)",
                    attributes: [
                        NSAttributedString.Key.foregroundColor: UIColor.white,
                        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue
                    ])
            }
            .disposed(by: trash)
        
        pickerView.rx.modelSelected(Camera.self)
            .compactMap { $0.first }
            .do(onNext: { [weak self] camera in
                self?.cameraButton.setTitle(camera.fullName, for: .normal)
            })
            .bind(to: selectedCamera)
            .disposed(by: trash)
        return pickerView
    }
    
    private func setupDatePicker() -> UIDatePicker {
        let pickerView = UIDatePicker()
        pickerView.minimumDate = minimumDate
        pickerView.maximumDate = maximumDate
        pickerView.datePickerMode = .date
        pickerView.backgroundColor = .gray
        pickerView.rx.date
            .do(onNext: { [weak self] date in
                self?.dateButton.setTitle(date.string(), for: .normal)
            })
            .bind(to: selectedDate)
            .disposed(by: trash)
        return pickerView
    }
    
    private func installBlur() {
        backgroundColor = .gray
//        let blurEffect = UIBlurEffect(style: .dark)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.translatesAutoresizingMaskIntoConstraints = false
//        insertSubview(blurView, at: 0)
    }
    
    private func installMainStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    func installPickerButton(with image: UIImage, title: String, leading: CGFloat = 15, trailing: CGFloat = 15) -> UIButton {
        let imageView = UIImageView(image: image)
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSerif", size: 12)
        button.titleLabel?.numberOfLines = 0
        button.contentHorizontalAlignment = .left
        let stack = UIStackView(arrangedSubviews: [imageView, button])
        stack.distribution = .fill
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: leading, bottom: 0, trailing: trailing)
        stack.spacing = 10
        imageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(20)
            maker.height.equalTo(20)
            maker.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints { (maker) in
            maker.height.equalTo(35)
            maker.width.greaterThanOrEqualTo(70)
        }
        if leading == 0 {
            stack.snp.makeConstraints { (maker) in
                maker.width.equalTo(130)
            }
        }
        
        self.stackView.addArrangedSubview(stack)
        return button
    }
    
    private var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
}

extension Date {
    func string() -> String {
        let formatter = DPDateFormatters.default
        return formatter.string(from: self)
    }
}
