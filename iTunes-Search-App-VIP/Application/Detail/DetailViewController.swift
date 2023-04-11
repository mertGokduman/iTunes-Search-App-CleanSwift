//
//  DetailViewController.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 11.04.2023.

import UIKit

protocol DetailDisplayLogic: AnyObject {
    func displayImage(viewModel: Detail.Something.ViewModel)
}

class DetailViewController: UIViewController, DetailDisplayLogic {

    private lazy var imgDetail: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var interactor: DetailBusinessLogic?
    var router: (NSObjectProtocol & DetailRoutingLogic & DetailDataPassing)?

    // MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    // MARK: - Setup VIP of Screen
    private func setup() {
        let interactor = DetailInteractor()
        let presenter = DetailPresenter()
        let router = DetailRouter()
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }

    // MARK: - VIEW LIFECYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false,
                                                     animated: false)
        presentImage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - SETUP UI
    private func setupUI() {

        view.backgroundColor = .white
        self.navigationItem.title = "Detail"

        view.addSubview(imgDetail)
        NSLayoutConstraint.activate([
            imgDetail.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imgDetail.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imgDetail.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imgDetail.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            imgDetail.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            imgDetail.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    // MARK: PRESENT IMAGE
    func presentImage() {
        let request = Detail.Something.Request()
        interactor?.presentImage(request: request)
    }

    func displayImage(viewModel: Detail.Something.ViewModel) {
        let image = viewModel.image
        self.imgDetail.image = image
    }
}
