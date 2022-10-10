//
//  FavoritesDetailVC.swift
//  iTunes Client App
//
//  Created by Oğuz Kaan Altun on 10.10.2022.
//

import UIKit
import CoreData

class FavoritesDetailVC: UIViewController {

    private let detailView = DetailView(media: .other)
    var favoriteMediaId: UUID?
    
    var releaseDate: String? {
        didSet {
            detailView.releaseDate = releaseDate
        }
    }
    var mediaOwnerName: String? {
        didSet {
            detailView.artistName = mediaOwnerName
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        
        let idString = favoriteMediaId?.uuidString
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let mediaName = result.value(forKey: "mediaName") as? String {
                        title = mediaName
                    }
                    if let mediaOwnerName = result.value(forKey: "mediaOwnerName") as? String {
                        self.mediaOwnerName = mediaOwnerName
                    }
                    if let artworkData = result.value(forKey: "artwork") as? Data {
                        let artwork = UIImage(data: artworkData)
                        detailView.imageView.image = artwork
                    }
                }
            }
        } catch  {
            print("Error detail")
        }
    }
    
    

}
