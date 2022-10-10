//
//  FavoritesVC.swift
//  iTunes Client App
//
//  Created by Oğuz Kaan Altun on 10.10.2022.
//

import UIKit
import CoreData

class FavoritesVC: UIViewController {

    private let mainView = MainView()
    private var mediaIDs = [UUID]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        mainView.setCollectionViewDelegate(self, andDataSource: self)
        view.backgroundColor = .systemYellow
        getData()
    }
    
    func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let id = result.value(forKey: "id") as? UUID {
                        self.mediaIDs.append(id)
                    }
                    mainView.refresh()
                }
            }
        } catch {
            print("error fetching")
        }
        
    }

}

extension FavoritesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = FavoritesDetailVC()
        detailVC.favoriteMediaId = mediaIDs[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension FavoritesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Podcast.favorites.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MediaCollectionViewCell
        let podcast = Podcast.favorites[indexPath.row]
        cell.title = podcast.trackName
        cell.imageView.downloadImage(from: podcast.artworkLarge)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
    
}
