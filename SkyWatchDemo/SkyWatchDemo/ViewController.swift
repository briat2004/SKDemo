//
//  ViewController.swift
//  SkyWatchDemo
//
//  Created by BruceWu on 2022/7/7.
//

import UIKit

class ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UsersCellDelegate, UISearchResultsUpdating {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
        tableView.backgroundColor = .white
        return tableView
    }()
    
    var searchController: UISearchController?
    
    let viewModel = SkyWatchViewModel()
    
    var filterAlbum: AlbumsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setNavigationBar(title: "App Title", textColor: .black)
        
        searchController = UISearchController()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController?.searchResultsUpdater = self
        
        setupViews()
        dataBinding()
    }
    
    func setupViews() {
        self.view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.register(UsersCell.self, forCellReuseIdentifier: "UsersCell")
        tableView.register(AlbumsCell.self, forCellReuseIdentifier: "AlbumsCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func dataBinding() {
        
        let queue = DispatchQueue(label: "com.SkyWatchDemo.queue", attributes: .concurrent)
        let group = DispatchGroup()
        
        group.enter()
        viewModel.gerUsers()
        group.enter()
        viewModel.gerAlbum()
        group.enter()
        viewModel.gerPhotos()
        
        queue.async {
            self.viewModel.users.bind { usersModel in
                guard let _ = usersModel else { return }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                group.leave()
            }
        }
        
        queue.async {
            self.viewModel.albums.bind { albumsModel in
                guard let _ = albumsModel else { return }
                group.leave()
            }
        }
        
        queue.async {
            self.viewModel.photos.bind { photos in
                guard let _ = photos else { return }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.viewModel.selectedAlbum() //default is 1
        }
        
        
        viewModel.selecteAlbun.bind { albumsModel in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as? UsersCell
            cell?.userModels = viewModel.users.value
            cell?.UCDelegate = self
            return cell!
        default:
            
            if searchController?.isActive ?? false {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumsCell", for: indexPath) as? AlbumsCell
                cell?.setCell(indexPath: indexPath, viewModel: viewModel, albumsModel: filterAlbum)
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumsCell", for: indexPath) as? AlbumsCell
                cell?.setCell(indexPath: indexPath, viewModel: viewModel, albumsModel: viewModel.selecteAlbun.value)
                return cell!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            if searchController?.isActive ?? false {
                return filterAlbum?.count ?? 0
            } else {
                return viewModel.selecteAlbun.value?.count ?? 0
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let albumPage = AlbumViewController()
            var photos: PhotosModel?
            if searchController?.isActive ?? false {
                photos = viewModel.photos.value?.filter({$0.albumID == filterAlbum?[indexPath.row].id})
            } else {
                photos = viewModel.photos.value?.filter({$0.albumID == viewModel.selecteAlbun.value?[indexPath.row].id})
            }
            albumPage.photosModel = photos
            self.navigationController?.pushViewController(albumPage, animated: true)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let albums = viewModel.selecteAlbun.value else { return }
        filterAlbum = albums.filter({$0.title.localizedStandardContains(searchController.searchBar.text ?? "")})
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    //MARK : - UsersCell Delegate
    func usersCellDidSelectAt(index: Int, userModel: UserModel) {
        guard let _ = viewModel.albums.value else { return }
        viewModel.selectedAlbum(userID: userModel.id)
    }
    
}

