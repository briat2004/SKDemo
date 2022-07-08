//
//  AlbumViewController.swift
//  SkyWatchDemo
//
//  Created by BruceWu on 2022/7/8.
//

import UIKit

class AlbumViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var photosModel: PhotosModel?
    
    deinit {
        print(type(of: self))
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.getLayout())
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let albumId = photosModel?.first?.albumID {
            let title = "Album " + String(albumId)
            setNavigationBar(title: title, textColor: .black)
        }
        
        setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: "PhotosCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as? PhotosCell
        if let imageUrlString = photosModel?[indexPath.row].thumbnailURL, let url = URL(string: imageUrlString) {
            cell?.imageView.image = nil
            ApiManager.instance.fetchImage(url: url) { image in
                DispatchQueue.main.async {
                    cell?.imageView.image = image
                }
            }
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosModel?.count ?? 0
    }
    
    private func getLayout() -> UICollectionViewCompositionalLayout {
        let mainHGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let mainHGroup = NSCollectionLayoutGroup.vertical(layoutSize: mainHGroupSize, subitems: [threeItemsGroup(),
                                                                                                 oneBigItemsGroup()])

        let section = NSCollectionLayoutSection(group: mainHGroup)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func oneBigItemsGroup() -> NSCollectionLayoutGroup {
        let sItem1 = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)))
        sItem1.contentInsets.trailing = 1
        let sItem2 = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)))
        sItem2.contentInsets.top = 1
        sItem2.contentInsets.trailing = 1
        let vGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.333), heightDimension: .fractionalHeight(1))
        let vGroup = NSCollectionLayoutGroup.vertical(layoutSize: vGroupSize, subitems: [sItem1, sItem2])
        
        
        let item1 = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.666), heightDimension: .fractionalHeight(1)))
        
        let GroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.666))
        let Group = NSCollectionLayoutGroup.horizontal(layoutSize: GroupSize, subitems: [vGroup, item1])
        Group.contentInsets.top = 1
        
        return Group
    }
    
    func threeItemsGroup() -> NSCollectionLayoutGroup {
        let sItem1 = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.333), heightDimension: .fractionalHeight(1)))
        sItem1.contentInsets.trailing = 1
        let sItem2 = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.333), heightDimension: .fractionalHeight(1)))
        sItem2.contentInsets.trailing = 1
        let sItem3 = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.333), heightDimension: .fractionalHeight(1)))
        
        let hGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.333))
        let hGroup = NSCollectionLayoutGroup.horizontal(layoutSize: hGroupSize, subitems: [sItem1, sItem2, sItem3])
        hGroup.contentInsets.top = 1
        return hGroup
    }
}
