//
//  SearchView.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 11.04.2023.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func beginEditing(text: String)
}

class SearchView: UIView {

    weak var delegate: SearchViewDelegate?

    private lazy var tfSearch: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 14,
                                           weight: .semibold)
        textField.textColor = .black
        textField.layer.borderColor =  UIColor.black.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 10
        textField.leftViewMode = .always
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .search
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    //LEFT VIEW OF TEXTFIELD
    private lazy var imgSearch: UIView = {
        let tempView = UIView()
        let tempImageView = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withTintColor(.lightGray))
        tempImageView.tintColor = .lightGray
        tempImageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        tempView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        tempView.addSubview(tempImageView)
        return tempView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    // MARK: - SETUP UI
    private func setupUI() {

        tfSearch.delegate = self
        tfSearch.leftView = imgSearch
        self.addSubview(tfSearch)
        NSLayoutConstraint.activate([
            tfSearch.topAnchor.constraint(equalTo: self.topAnchor),
            tfSearch.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tfSearch.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tfSearch.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    //SETUP TEXTFIELD PLACEHOLDER
    func setupSearchTF(placeholder: String) {
        tfSearch.attributedPlaceholder = NSAttributedString( string: placeholder,
                                                             attributes: [
                                                                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14,
                                                                                                               weight: .semibold)
                                                             ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}

extension SearchView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        delegate?.beginEditing(text: textField.text~)
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.beginEditing(text: "")
        return true
    }

//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        delegate?.beginEditing(text: "")
//    }
}
