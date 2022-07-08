//
//  AlbumsCell.swift
//  SkyWatchDemo
//
//  Created by BruceWu on 2022/7/8.
//

import UIKit

class AlbumsCell: UITableViewCell {
    
    var photoImageView: UserPhotoImage = {
        let iv = UserPhotoImage()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var detailLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var imageCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 32)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var paddingInset = UIEdgeInsets(top: 8, left: 8, bottom: -8, right: -8)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.selectionStyle = .none
        self.addSubview(photoImageView)
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: paddingInset.left).isActive = true
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: paddingInset.top).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: paddingInset.left).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: paddingInset.top).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: paddingInset.right).isActive = true
        
        self.addSubview(detailLabel)
        detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: paddingInset.top).isActive = true
        
        self.addSubview(imgView)
        imgView.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor).isActive = true
        imgView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: paddingInset.top).isActive = true
        imgView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        imgView.addSubview(imageCountLabel)
        imageCountLabel.centerXAnchor.constraint(equalTo: imgView.centerXAnchor).isActive = true
        imageCountLabel.centerYAnchor.constraint(equalTo: imgView.centerYAnchor).isActive = true
        imageCountLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageCountLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.bottomAnchor.constraint(equalTo: imgView.bottomAnchor, constant: paddingInset.top).isActive = true
        
        
    }
    
    func setCell(indexPath: IndexPath, viewModel: SkyWatchViewModel, albumsModel: AlbumsModel?) {
        self.titleLabel.text = viewModel.users.value?.filter({$0.id == albumsModel?.first?.userID}).first?.name //用戶名稱
        self.detailLabel.text = albumsModel?[indexPath.row].title //相簿名稱
        self.imageCountLabel.text = String(viewModel.photos.value?.filter({$0.albumID == albumsModel?[indexPath.row].id}).count ?? 0) + " Photos"
        
        if let photoImageString = viewModel.users.value?.filter({$0.id == albumsModel?.first?.userID}).first?.imageName {
            self.photoImageView.image = UIImage(named: photoImageString)
        }
        
        if let imageUrlString = viewModel.photos.value?.filter({$0.albumID == albumsModel?[indexPath.row].id}).first?.thumbnailURL,
           let imageUrl = URL(string: imageUrlString) {
            self.imgView.image = nil
            ApiManager.instance.fetchImage(url: imageUrl) { image in
                DispatchQueue.main.async {
                    self.imgView.image = image
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
