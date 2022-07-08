//
//  SkyWatchViewModel.swift
//  SkyWatchDemo
//
//  Created by BruceWu on 2022/7/7.
//

import Foundation

class SkyWatchViewModel {
    
    let users: Box<UsersModel?> = Box(nil)
    let albums: Box<AlbumsModel?> = Box(nil)
    let photos: Box<PhotosModel?> = Box(nil)
    let selecteAlbun: Box<AlbumsModel?> = Box(nil)
    
    func gerUsers() {
        ApiManager.instance.get(path: .users) { data in
            do {
                var usersModel = try JSONDecoder().decode(UsersModel.self, from: data)
                //api沒大頭貼，假資料
                for i in 0..<self.fakeData().count {
                    usersModel[i].imageName = self.fakeData()[i]
                }
                self.users.value = usersModel
            } catch {
                print(error)
            }
        } failute: { err in
            print(err)
        }
    }
    
    func gerAlbum() {
        ApiManager.instance.get(path: .albums) { data in
            do {
                let usersModel = try JSONDecoder().decode(AlbumsModel.self, from: data)
                self.albums.value = usersModel
            } catch {
                print(error)
            }
        } failute: { err in
            print(err)
        }
    }
    
    func gerPhotos() {
        ApiManager.instance.get(path: .photos) { data in
            do {
                let usersModel = try JSONDecoder().decode(PhotosModel.self, from: data)
                self.photos.value = usersModel
            } catch {
                print(error)
            }
        } failute: { err in
            print(err)
        }
    }
    
    func selectedAlbum(userID: Int = 1) {
        selecteAlbun.value = albums.value?.filter({$0.userID == userID})
    }
    
    
    private func fakeData() -> [String] {
        return ["myself1", "myself2", "myself3", "myself4", "myself5", "myself6", "myself7", "myself8", "myself9", "myself10"]
    }
}
