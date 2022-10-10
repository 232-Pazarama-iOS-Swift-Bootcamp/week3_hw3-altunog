//
//  PodcastDetailVC.swift
//  iTunes Client App
//
//  Created by Pazarama iOS Bootcamp on 2.10.2022.
//

import UIKit
import CoreData

final class PodcastDetailVC: UIViewController {
    
    var podcast: Podcast? {
        didSet {
            title = podcast?.trackName
            detailView.imageView.downloadImage(from: podcast?.artworkLarge)
            detailView.releaseDate = podcast?.releaseDate
            detailView.artistName = podcast?.artistName
            detailView.country = podcast?.country
            detailView.genres = podcast?.genres?.joined(separator: ", ")
        }
    }
    
    private var isFavorited: Bool = false

    private var favoriteButton = UIBarButtonItem()
    
    private let detailView = DetailView(media: .podcast)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        
        view = detailView
    }
    
    private func configureItems() {
        navigationItem.largeTitleDisplayMode = .never
        
        favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped))
        
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    @objc func favoriteButtonTapped() {
        guard let podcast = podcast else { return }

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        if isFavorited { // remove if it is already favorited
            guard let index = Podcast.favorites.firstIndex(where: { $0 == podcast }) else { return }
            Podcast.favorites.remove(at: index)
            favoriteButton.image = UIImage(systemName: "heart")
            
            print("Removed from fav")
        } else { // else append to favorite podcasts array
            
            Podcast.favorites.append(podcast)
            favoriteButton.image = UIImage(systemName: "heart.fill")
            
            let favPodcast = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: context)
            
            favPodcast.setValue(UUID(), forKey: "id")
            favPodcast.setValue(MediaType.podcast.rawValue, forKey: "mediaType")
            favPodcast.setValue(podcast.trackName, forKey: "mediaName")
            favPodcast.setValue(podcast.artistName, forKey: "mediaOwnerName")
            favPodcast.setValue(podcast.releaseDate, forKey: "releaseDate")
            
            let image = detailView.imageView.image?.jpegData(compressionQuality: 1.0)
            favPodcast.setValue(image, forKey: "artwork")
            
            do {
                try context.save()
                print("Added to fav")
            } catch {
                print("Podcast not saved.")
            }
        }
        
        isFavorited.toggle()
    }

}

