
import UIKit
import SnapKit
import SwiftRichString
import Then

enum InputFieldState {
    case normal
    case editting
    case warning
}


public class PlaceholderTextField: UIView {
    open var placeholder = "Placeholder" {
        didSet {
            updateTitleText()
        }
    }
    
    open var text: String? {
        get {
            return textField.text
        }
        set {
            isActive = !(newValue ?? "").isEmpty
            textField.text = newValue
            updateClearButton()
            animate(isAnimated: false)
        }
    }
    
    open var height: CGFloat? {
        didSet {
            if let height = height {
                self.snp.remakeConstraints {
                    $0.height.equalTo(height)
                }
            }
        }
    }
    open var cornerRadius: CGFloat = 5 {
        didSet {
            updateBorder()
        }
    }
    open var isSecure = false {
        didSet {
            setupTextFieldType()
        }
    }
    open var hasClearButton = true {
        didSet {
            updateClearButton()
        }
    }
    open var isRequired = false {
        didSet {
            updateTitleText()
        }
    }
    open var limitCharacter = -1
    open var rightIcon: UIImage? {
        didSet {
            setUpRightIcon()
        }
    }
    
    
    open var rightButtonAction: (() -> Void)?
    open var placeholderActiveFont: UIFont = .systemFont(ofSize: 12) {
        didSet {
            updateTitleText()
        }
    }
    open var placeholderInactiveFont: UIFont = .systemFont(ofSize: 14) {
        didSet {
            updateTitleText()
        }
    }
    open var font: UIFont = .systemFont(ofSize: 16) {
        didSet {
            textField.font = font
        }
    }
    
    open var textColor: UIColor = UIColor.colorFromHexString("#101012") {
        didSet {
            textField.textColor = textColor
        }
    }
    open var warningColor: UIColor = UIColor.colorFromHexString("#ff6663")
    
    open var selectedColor = UIColor.colorFromHexString("#723562")
    open var normalColor = UIColor.colorFromHexString("#d8dbdf")
    
    open var placeholderColor = UIColor.colorFromHexString("#7c7f83")
    open var borderCornerRadius: CACornerMask = [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner] {
        didSet {
            updateBorder()
        }
    }
    
    
    lazy var textField = UITextField().then {
        $0.font = font
        $0.autocapitalizationType = .none
        $0.spellCheckingType = .no
        $0.textColor = textColor
    }
    lazy var titleLabel = UILabel()
    lazy var rightStackIcons = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    lazy var fieldIconButton = UIButton()
    lazy var clearIconButton = UIButton().then {
        $0.tintColor = UIColor.colorFromHexString("#d8dbdf")
        $0.setImage(getImageFromBundle(name: "clear_ic")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.addTarget(self, action: #selector(clearTextAction), for: .touchUpInside)
        $0.isHidden = true
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    private var moveOffset: CGFloat = 12
    private var isActive: Bool = false
    
    private var normal: Style {
        return Style {
            $0.font = self.isActive ? self.placeholderActiveFont : self.placeholderInactiveFont
            $0.color = self.textField.isFirstResponder ? self.selectedColor : self.placeholderColor
            $0.kerning = Kerning.point(-0.09)
        }
    }

    private var red: Style {
        return Style {
            $0.font = self.isActive ? self.placeholderActiveFont : self.placeholderInactiveFont
            $0.color = self.warningColor
            $0.kerning = Kerning.point(-0.1)
        }
    }
    
    var fieldState: InputFieldState = .normal {
        didSet {
            updateFieldState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createSubViews()
    }
    
    public convenience init(placeholder: String, height: CGFloat = 56) {
        self.init()
        defer {
            self.placeholder = placeholder
            self.height = height
            createSubViews()
        }
        
    }
    
    private func getImageFromBundle(name: String) -> UIImage? {
       let podBundle = Bundle(for: PlaceholderTextField.self)
       if let url = podBundle.url(forResource: "PlaceholderTextView", withExtension: "bundle") {
          let bundle = Bundle(url: url)
          return UIImage(named: name, in: bundle, compatibleWith: nil)
       }
       return UIImage()
    }
    
    private func updateBorder() {
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = borderCornerRadius
        self.layer.borderWidth = 1
        self.layer.borderColor = normalColor.cgColor
    }
    
    private func updateTitleText() {
        if isRequired {
            titleLabel.attributedText = AttributedString.composing {
                placeholder.set(style: normal)
                "※".set(style: red)
            }
        } else {
            titleLabel.attributedText = AttributedString.composing {
                placeholder.set(style: normal)
            }
        }
    }
    
    private func setupTextFieldType() {
        textField.isSecureTextEntry = isSecure
        textField.keyboardType = .default
    }
    
    private func setUpRightIcon() {
        fieldIconButton.setImage(rightIcon, for: .normal)
        rightStackIcons.addArrangedSubview(fieldIconButton)
        fieldIconButton.snp.makeConstraints {
            $0.width.equalTo(40)
        }
    }
    
    func createSubViews() {
        updateBorder()

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(8)
        }
        updateTitleText()
        
        addSubview(rightStackIcons)
        rightStackIcons.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.height.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        let lineView = UIView()
        lineView.snp.makeConstraints {
            $0.width.equalTo(1)
        }
        
        rightStackIcons.addArrangedSubview(lineView)
        rightStackIcons.addArrangedSubview(clearIconButton)
        clearIconButton.snp.makeConstraints {
            $0.width.equalTo(40)
        }
        
        addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(8)
            $0.right.equalTo(self.rightStackIcons.snp.left)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(edittingChanged), for: .editingChanged)
        
        fieldIconButton.addTarget(self, action: #selector(rightIconAction), for: .touchUpInside)
    }
    
    private func animate(isAnimated: Bool? = nil) {
        let duration = (isAnimated == false) ? 0.0 : 0.1
        UIView.animate(withDuration: duration) {
            self.textField.snp.remakeConstraints {
                $0.left.equalToSuperview().inset(8)
                $0.right.equalTo(self.rightStackIcons.snp.left)
                $0.bottom.equalToSuperview().inset(8)
                if self.isActive {
                    $0.top.equalToSuperview().inset(8+self.moveOffset)
                } else {
                    $0.top.equalToSuperview().inset(8)
                }
            }
            self.updateTitleText()
            self.titleLabel.snp.remakeConstraints {
                if self.isActive {
                    $0.centerY.equalToSuperview().offset(-self.moveOffset)
                } else {
                    $0.centerY.equalToSuperview()
                }
                $0.left.equalToSuperview().inset(8)
            }
            self.layoutIfNeeded()
        }
    }
    
    @objc func rightIconAction() {
        if isSecure {
            fieldIconButton.isSelected = !fieldIconButton.isSelected
            textField.isSecureTextEntry = !textField.isSecureTextEntry
        } else if let action = rightButtonAction {
            action()
        } else {
            textField.sendActions(for: .editingChanged)
        }
    }
    
    @objc func clearTextAction() {
        UIView.animate(withDuration: 0.1) {
            self.textField.text = ""
            self.layoutIfNeeded()
        } completion: { complete in
            self.clearIconButton.isHidden = self.textField.text == nil || self.textField.text == ""
        }
        animate()
        textField.sendActions(for: .editingChanged)
        textField.becomeFirstResponder()
    }
    
    private func updateClearButton() {
        if !hasClearButton {
            clearIconButton.isHidden = true
        } else {
            clearIconButton.isHidden = textField.text == nil || textField.text == "" || !textField.isFirstResponder
        }
    }
    
    private func updateFieldState() {
        UIView.animate(withDuration: 0.1) {
            switch self.fieldState {
            case .editting:
                self.layer.borderColor = self.selectedColor.cgColor
            case .normal:
                self.layer.borderColor = self.normalColor.cgColor
            case .warning:
                self.layer.borderColor = self.warningColor.cgColor
            }
            self.updateTitleText()
        }
    }
}

extension PlaceholderTextField: UITextFieldDelegate {
    @objc func edittingChanged() {
        animate()
        updateClearButton()
        updateFieldState()
    }
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isActive = true
        UIView.animate(withDuration: 0.1) {
            self.updateTitleText()
            self.superview?.bringSubviewToFront(self)
        }
        animate()
        fieldState = .editting
        updateClearButton()
        updateFieldState()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.isActive = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty == false
        UIView.animate(withDuration: 0.1) {
            self.updateTitleText()
            self.superview?.bringSubviewToFront(self)
        }
        animate()
        if !isRequired {
            fieldState = .normal
            updateFieldState()
        } else {
            fieldState = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty == false ? .normal : .warning
            updateFieldState()
        }
        updateClearButton()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if limitCharacter >= 1 {
            if let textFieldText = textField.text,
               let rangeOfTextToReplace = Range(range, in: textFieldText) {
                let substringToReplace = textFieldText[rangeOfTextToReplace]
                let count = textFieldText.count - substringToReplace.count + string.count
                return count <= limitCharacter
            }
        }
        return true
    }
}

extension UIColor {
    static func colorFromHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

