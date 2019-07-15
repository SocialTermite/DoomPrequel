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
        return selectedCamera.skip(1).asObservable()
    }
    
    var selectedDateObservable: Observable<Date> {
        return selectedDate.skip(1).asObservable()
    }
    
    private var cameraTF: UITextView!
    private var dateTF: UITextView!
    private var cameraPicker: UIPickerView!
    private var datePicker: UIDatePicker!
    
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
        return cameraTF.isFirstResponder || dateTF.isFirstResponder
    }
    
    
    private func setupUI() {
        blurView.setup(style: UIBlurEffect.Style.dark, alpha: 0.9).enable()
        installMainStackView()
        cameraTF = installPickerButton(with: UIImage(named: "whiteCamera")!,
                                           title: selectedCamera.value.fullName,
                                           trailing: 0)
        dateTF = installPickerButton(with:  UIImage(named: "calendar")!,
                                         title: selectedDate.value.string(),
                                         leading: 0)
        
        cameraPicker = setupCameraPicker()
        datePicker = setupDatePicker()
        
        cameraTF.inputView = cameraPicker
        dateTF.inputView = datePicker
        cameraTF.inputAccessoryView = doneToolbar()
        dateTF.inputAccessoryView = doneToolbar()
        
    }
    
    private func setupCameraPicker() -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .gray
        let selectedIndex = cameras.firstIndex(where: {[selectedCamera] in $0.fullName == selectedCamera.value.fullName }) ?? 0
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        Observable
            .just(cameras)
            .bind(to: pickerView.rx.itemAttributedTitles) { _, item in
                return NSAttributedString(string: "\(item.fullName)",
                    attributes: [
                        NSAttributedString.Key.foregroundColor: UIColor.white
                    ])
            }
            .disposed(by: trash)
        
        pickerView.rx.modelSelected(Camera.self)
            .compactMap { $0.first }
            .do(onNext: { [weak self] camera in
                self?.cameraTF.text = camera.fullName
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
                self?.dateTF.text = date.string()
            })
            .bind(to: selectedDate)
            .disposed(by: trash)
        return pickerView
    }
    
    private func installMainStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
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
    
    func installPickerButton(with image: UIImage, title: String, leading: CGFloat = 15, trailing: CGFloat = 15) -> UITextView {
        let imageView = UIImageView(image: image)
        let tf = UITextView(frame: .zero)
        tf.text = title
        tf.isEditable = false
        tf.backgroundColor = .clear
        tf.font =  Constants.Font.h3.font()
        tf.textColor = .white
        tf.textAlignment = .left
        let stack = UIStackView(arrangedSubviews: [imageView, tf])
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
        
        tf.snp.makeConstraints { (maker) in
            maker.height.equalTo(35)
            maker.width.greaterThanOrEqualTo(70)
        }
        if leading == 0 {
            stack.snp.makeConstraints { (maker) in
                maker.width.equalTo(130)
            }
        }
        
        self.stackView.addArrangedSubview(stack)
        return tf
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

extension UIView {
    
    private struct AssociatedKeys {
        static var descriptiveName = "AssociatedKeys.DescriptiveName.blurView"
    }
    
    private (set) var blurView: BlurView {
        get {
            if let blurView = objc_getAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName
                ) as? BlurView {
                return blurView
            }
            self.blurView = BlurView(to: self)
            return self.blurView
        }
        set(blurView) {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName,
                blurView,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    class BlurView {
        
        private var superview: UIView
        private var blur: UIVisualEffectView?
        private var editing: Bool = false
        private (set) var blurContentView: UIView?
        private (set) var vibrancyContentView: UIView?
        
        var animationDuration: TimeInterval = 0.1
        
        /**
         * Blur style. After it is changed all subviews on
         * blurContentView & vibrancyContentView will be deleted.
         */
        var style: UIBlurEffect.Style = .light {
            didSet {
                guard oldValue != style,
                    !editing else { return }
                applyBlurEffect()
            }
        }
        /**
         * Alpha component of view. It can be changed freely.
         */
        var alpha: CGFloat = 0 {
            didSet {
                guard !editing else { return }
                if blur == nil {
                    applyBlurEffect()
                }
                let alpha = self.alpha
                UIView.animate(withDuration: animationDuration) {
                    self.blur?.alpha = alpha
                }
            }
        }
        
        init(to view: UIView) {
            self.superview = view
        }
        
        func setup(style: UIBlurEffect.Style, alpha: CGFloat) -> Self {
            self.editing = true
            
            self.style = style
            self.alpha = alpha
            
            self.editing = false
            
            return self
        }
        
        func enable(isHidden: Bool = false) {
            if blur == nil {
                applyBlurEffect()
            }
            
            self.blur?.isHidden = isHidden
        }
        
        private func applyBlurEffect() {
            blur?.removeFromSuperview()
            
            applyBlurEffect(
                style: style,
                blurAlpha: alpha
            )
        }
        
        private func applyBlurEffect(style: UIBlurEffect.Style,
                                     blurAlpha: CGFloat) {
            superview.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            blurEffectView.contentView.addSubview(vibrancyView)
            
            blurEffectView.alpha = blurAlpha
            
            superview.insertSubview(blurEffectView, at: 0)
            
            blurEffectView.addAlignedConstrains()
            vibrancyView.addAlignedConstrains()
            
            self.blur = blurEffectView
            self.blurContentView = blurEffectView.contentView
            self.vibrancyContentView = vibrancyView.contentView
        }
    }
    
    private func addAlignedConstrains() {
        translatesAutoresizingMaskIntoConstraints = false
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.top)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.leading)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.trailing)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.bottom)
    }
    
    private func addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute) {
        superview?.addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: 0
            )
        )
    }
}
