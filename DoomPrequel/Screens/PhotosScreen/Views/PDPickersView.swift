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
    
    private var cameraTV: UITextView!
    private var dateTV: UITextView!
    private var cameraPicker: UIPickerView!
    private var datePicker: UIDatePicker!
    
    private var cameras: [Camera]
    private var minimumDate: Date
    private var maximumDate: Date
    private var selectedCamera: BehaviorRelay<Camera>
    private var selectedDate: BehaviorRelay<Date>
    
    var selectedCameraObservable: Observable<Camera> {
        return selectedCamera.skip(1).asObservable()
    }
    
    var selectedDateObservable: Observable<Date> {
        return selectedDate.skip(1).asObservable()
    }
    
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
    
    @objc func dissmiss() {
        endEditing(true)
    }
    
    func isPresenting() -> Bool {
        return cameraTV.isFirstResponder || dateTV.isFirstResponder
    }
    
    
    private func setupUI() {
        blurView.setup(style: UIBlurEffect.Style.dark, alpha: 0.9).enable()
        
        installMainStackView()
        installCameraPicker()
        installDatePicker()
    }
    
    private func installMainStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func installCameraPicker() {
        cameraTV = installedPickerTextView(with: UIImage(named: "whiteCamera")!,
                                       title: selectedCamera.value.fullName,
                                       trailing: 0)
        cameraPicker = setupCameraPicker()
        cameraTV.inputView = cameraPicker
        cameraTV.inputAccessoryView = doneToolbar()
    }
    
    private func installDatePicker() {
        dateTV = installedPickerTextView(with:  UIImage(named: "calendar")!,
                                     title: selectedDate.value.string(),
                                     leading: 0)
        datePicker = setupDatePicker()
        dateTV.inputView = datePicker
        dateTV.inputAccessoryView = doneToolbar()
    }
    
    private func setupCameraPicker() -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .gray
        
        let selectedIndex = cameras.firstIndex(where: {[selectedCamera] in $0.fullName == selectedCamera.value.fullName }) ?? 0
        
        Observable
            .just(cameras)
            .bind(to: pickerView.rx.itemAttributedTitles) { _, item in
                return NSAttributedString(string: "\(item.fullName)",
                    attributes: [
                        NSAttributedString.Key.foregroundColor: UIColor.white
                    ])
            }
            .disposed(by: trash)
        
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        
        pickerView.rx.modelSelected(Camera.self)
            .compactMap { $0.first }
            .do(onNext: { [weak self] camera in
                self?.cameraTV.text = camera.fullName
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
        pickerView.date = selectedDate.value
        pickerView.setValue(UIColor.white, forKeyPath: "textColor")
        
        pickerView.rx.date
            .do(onNext: { [weak self] date in
                self?.dateTV.text = date.string()
            })
            .bind(to: selectedDate)
            .disposed(by: trash)
        return pickerView
    }
    
    private func doneToolbar() -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.width, height: 44))
        toolBar.barStyle = UIBarStyle.black
        toolBar.tintColor = .darkGray
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dissmiss))
        doneButton.setTitleTextAttributes([.font: Constants.Font.h2.font()], for: .normal)
        doneButton.tintColor = .white
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.contentMode = .center
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    func installedPickerTextView(with image: UIImage, title: String, leading: CGFloat = 15, trailing: CGFloat = 15) -> UITextView {
        let imageView = UIImageView(image: image)
        
        let textView = pickerTextView(title)
        
        let stack = UIStackView(arrangedSubviews: [imageView, textView])
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
        
        textView.snp.makeConstraints { (maker) in
            maker.height.equalTo(35)
            maker.width.greaterThanOrEqualTo(70)
        }
        if leading == 0 {
            stack.snp.makeConstraints { (maker) in
                maker.width.equalTo(130)
            }
        }
        
        self.stackView.addArrangedSubview(stack)
        return textView
    }
    
    private func pickerTextView(_ title: String) -> UITextView {
        let textView = UITextView(frame: .zero)
        textView.text = title
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.font =  Constants.Font.h3.font()
        textView.textColor = .white
        textView.textAlignment = .left
        return textView
    }
    
    private var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
}
