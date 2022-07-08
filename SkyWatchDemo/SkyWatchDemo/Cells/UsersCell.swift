//
//  UsersCell.swift
//  SkyWatchDemo
//
//  Created by BruceWu on 2022/7/7.
//

import UIKit

protocol UsersCellDelegate: NSObject {
    func usersCellDidSelectAt(index: Int, userModel: UserModel)
}

class UsersCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var UCDelegate: UsersCellDelegate?
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    var userModels: UsersModel? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .white
        self.contentView.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        collectionView.register(UserPhotoInfoCell.self, forCellWithReuseIdentifier: "UserPhotoInfoCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPhotoInfoCell", for: indexPath) as? UserPhotoInfoCell
        if let imageString = userModels?[indexPath.row].imageName {
            cell?.imageView.image = UIImage(named: imageString)
        }
        cell?.title.text = userModels?[indexPath.row].name
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 84)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let UCDelegate = UCDelegate, let userModels = userModels else { return }
        UCDelegate.usersCellDidSelectAt(index: indexPath.row, userModel: userModels[indexPath.row])
    }
}


class UserPhotoInfoCell: UICollectionViewCell {
    
    var imageView: UserPhotoImage = {
        let iv = UserPhotoImage()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var title: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 9)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(title)
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        title.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.contentView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: title.topAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class UserPhotoImage: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}
