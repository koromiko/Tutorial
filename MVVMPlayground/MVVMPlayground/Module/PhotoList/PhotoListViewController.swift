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
    
    var photos: [Photo] = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        APIService().fetchPopularPhoto { (success, photos, error) in
            DispatchQueue.main.async {
                self.photos = photos
                self.tableView.reloadData()
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
        cell.descriptionLabel.text = photo.description
        
        //Date
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

class PhotoListTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descContainerHeightConstraint: NSLayoutConstraint!
}

