//
//  PhotoListViewModel.swift
//  MVVMPlayground
//
//  Created by Neo on 03/10/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation

class PhotoListViewModel {
    
    let apiService: APIServiceProtocol

    var photos: [Photo] = [Photo]()
    
    var cellViewMdoels: [PhotoListCellViewModel] = [PhotoListCellViewModel]()
    
    var numberOfCells: Int {
        return cellViewMdoels.count
    }
    
    var isAllowSegue: Bool = false
    
    var selectedPhoto: Photo?

    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (( _ message: String )->())?
    var updateLoadingStatus: ((Bool)->())?
    
    init( apiService: APIServiceProtocol ) {
        self.apiService = apiService
    }
    
    func viewIsReady() {
        
        self.updateLoadingStatus?( true )
        apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
            self?.photos = photos
            self?.updateCellViewModel()
            self?.updateLoadingStatus?(false)
            self?.reloadTableViewClosure?()
        }
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> PhotoListCellViewModel {
        return cellViewMdoels[indexPath.row]
    }
    
    func createCellViewModel( photo: Photo ) -> PhotoListCellViewModel {

        //Wrap a description
        var descTextContainer: [String] = [String]()
        if let camera = photo.camera {
            descTextContainer.append(camera)
        }
        if let description = photo.description {
            descTextContainer.append( description )
        }
        let desc = descTextContainer.joined(separator: " - ")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return PhotoListCellViewModel( titleText: photo.name,
                                       descText: desc,
                                       imageUrl: photo.image_url,
                                       dateText: dateFormatter.string(from: photo.created_at) )
    }
    
    private func updateCellViewModel() {
        var vms = [PhotoListCellViewModel]()
        for photo in photos {
            vms.append( createCellViewModel(photo: photo) )
        }
        self.cellViewMdoels = vms
    }
    
}

extension PhotoListViewModel {
    func userPressed( at indexPath: IndexPath ){
        let photo = self.photos[indexPath.row]
        if photo.for_sale {
            self.isAllowSegue = true
            self.selectedPhoto = photo
        }else {
            self.isAllowSegue = false
            self.selectedPhoto = nil
            self.showAlertClosure?( "This item is not for sale")
        }
        
    }
}


struct PhotoListCellViewModel {
    let titleText: String
    let descText: String
    let imageUrl: String
    let dateText: String
}
