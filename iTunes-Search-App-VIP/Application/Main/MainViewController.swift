//
//  MainViewController.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 6.04.2023.

import UIKit

protocol MainDisplayLogic: AnyObject {
    func displaySearchResults(viewModel: Main.Something.ViewModel)
    func displaySearchImage(indexPath: IndexPath)
}

class MainViewController: UIViewController, MainDisplayLogic {

    private lazy var searchBar: SearchView = {
        let view = SearchView()
        view.backgroundColor = .clear
        view.setupSearchTF(placeholder: "Search characters...")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        return flowLayout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: "MainCVC",
                                      bundle: nil),
                                forCellWithReuseIdentifier: "MainCVC")
        collectionView.register(UINib(nibName: "CollectionViewHeaderReusableView",
                                      bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "CollectionViewHeaderReusableView")
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 25, right: 20)
        return collectionView
    }()

    var interactor: MainBusinessLogic?
    var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?

    var sections: [ImageSize] = [.under100, .between100250, .between250500, .over500]
    var sectionTitles: [String] = ["0-100KB", "101-250KB", "251-500KB", "500KB-"]

    var imageGroup1: [URL] = []
    var imageGroup2: [URL] = []
    var imageGroup3: [URL] = []
    var imageGroup4: [URL] = []

    // MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil,
                   bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup VIP of Screen
    private func setup() {
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
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

        navigationController?.setNavigationBarHidden(true,
                                                     animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        makeViewDismissKeyboard(cancelsTouchesInView: false)
    }

    // MARK: - SETUP UI
    private func setupUI() {

        view.backgroundColor = .white

        searchBar.delegate = self
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])

        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - GET SEARCH DATA
    func fetchSearchResult(searchTerm: String) {
        let requestModel = SearchRequestModel(searchTerm: searchTerm)
        let request = Main.Something.Request(model: requestModel)
        interactor?.fetchResults(request: request)
    }

    // MARK: - PRESENT SEARCH RESULT
    func displaySearchResults(viewModel: Main.Something.ViewModel) {
        self.imageGroup1 = viewModel.model.imageGroup1
        self.imageGroup2 = viewModel.model.imageGroup2
        self.imageGroup3 = viewModel.model.imageGroup3
        self.imageGroup4 = viewModel.model.imageGroup4
        self.collectionView.reloadData()
    }

    func displaySearchImage(indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.collectionView.performBatchUpdates {
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let section = self.sections[section]
        switch section {
        case .under100:
            return imageGroup1.count
        case .between100250:
            return imageGroup2.count
        case .between250500:
            return imageGroup3.count
        case .over500:
            return imageGroup4.count
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCVC",
                                                            for: indexPath) as? MainCVC else { return UICollectionViewCell() }
        if let model = interactor?.images.first(where: { $0.section == indexPath.section && $0.row == indexPath.row }),
           let image = model.image {
            cell.fillCell(with: image)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                               withReuseIdentifier: "CollectionViewHeaderReusableView",
                                                                               for: indexPath) as? CollectionViewHeaderReusableView else { return UICollectionReusableView() }
        headerView.fillHeader(with: self.sectionTitles[indexPath.section])
        return headerView
    }
}

// MARK: -
extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        router?.routeToDetail(destination: DetailViewController(),
                              indexPath: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (getScreenSize().width - 60) / 3
        return CGSize(width: width,
                      height: 150)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: getScreenSize().width,
                      height: 50)
    }
}

// MARK: - SearchViewDelegate
extension MainViewController: SearchViewDelegate {

    func beginEditing(text: String) {
        if !text.isEmpty {
            self.imageGroup1 = []
            self.imageGroup2 = []
            self.imageGroup3 = []
            self.imageGroup4 = []
            fetchSearchResult(searchTerm: text)
            collectionView.isHidden = false
        } else {
            collectionView.isHidden = true
        }
    }
}
