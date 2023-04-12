//
//  EmptyView.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 12.04.2023.
//

import UIKit

final class EmptyView: UIView {

    private lazy var imgEmpty: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "noResults")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20,
                                 weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "There is no result."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    private func setupUI() {

        self.addSubview(imgEmpty)
        NSLayoutConstraint.activate([
            imgEmpty.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            imgEmpty.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            imgEmpty.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            imgEmpty.heightAnchor.constraint(equalTo: imgEmpty.widthAnchor)
        ])

        self.addSubview(lblTitle)
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: imgEmpty.bottomAnchor, constant: 20),
            lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            lblTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            lblTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}
