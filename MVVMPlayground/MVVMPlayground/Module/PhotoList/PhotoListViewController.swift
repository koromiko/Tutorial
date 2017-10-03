//
//  EventListViewController.swift
//  MVVMPlayground
//
//  Created by Neo on 01/10/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var photos: [Photo] = [Photo]()
    
    var selectedIndexPath: IndexPath?
    
    lazy var apiService: APIService = {
        return APIService()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init the static view
        initView()
        
        // Fetch data from server
        initData()
        
    }
    
    func initView() {
        self.navigationItem.title = "Popular"
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func initData() {
        apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
            DispatchQueue.main.async {
                self?.photos = photos
                
                self?.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self?.tableView.alpha = 1.0
                })

                self?.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

extension PhotoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCellIdentifier", for: indexPath) as? PhotoListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let photo = self.photos[indexPath.row]
        //Text
        cell.nameLabel.text = photo.name
        
        //Wrap a description
        var descText: [String] = [String]()
        if let camera = photo.camera {
            descText.append(camera)
        }
        if let description = photo.description {
            descText.append( description )
        }
        cell.descriptionLabel.text = descText.joined(separator: " - ")
        
        //Wrap the date
        let dateFormateer = DateFormatter()
        dateFormateer.dateFormat = "yyyy-MM-dd"
        cell.dateLabel.text = dateFormateer.string(from: photo.created_at)

        //Image
        cell.mainImageView.sd_setImage(with: URL(string: photo.image_url), completed: nil)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let photo = self.photos[indexPath.row]
        if photo.for_sale {
            self.selectedIndexPath = indexPath
            return indexPath
        }else {
            let alert = UIAlertController(title: "Not for sale", message: "This item is not for sale", preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return nil
        }
    }

}

extension PhotoListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PhotoDetailViewController,
            let indexPath = self.selectedIndexPath {
            let photo = self.photos[indexPath.row]
            vc.imageUrl = photo.image_url
        }
    }
}

class PhotoListTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descContainerHeightConstraint: NSLayoutConstraint!
}

