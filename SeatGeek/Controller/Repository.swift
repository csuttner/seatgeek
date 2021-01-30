//
//  Repository.swift
//  SeatGeek
//
//  Created by Clay Suttner on 1/29/21.
//

// This Repository is a central Singleton go-between for the different models used to elsewhere in the app
// It temporarily houses data from the SeatGeek API in-memory, and manages interactions with the Core Data LikeModel

import UIKit
import CoreData

class Repository {
    
    // In-memory storage of data from web
    // Events are parsed from JSON using EventsRequest
    private var events = [Event]()
    
    // Simple cache of images using dictionary of event ids and UIImages
    private var imageCache = [Int64 : UIImage]()
    
    // Dictionary of strings to be searched with searchbar query
    private var searchStrings = [Int64 : String]()
    
    // Variable to hold the delegate of this Repository, so we can trigger table update on data fetch completion
    var repoDelegate: RepoDelegate!
    
    // References to appDelegate and viewContext for brevity later on
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    lazy var context = appDelegate.persistentContainer.viewContext
    
    // Repository is a single instance go between for models and views, avoiding data duplication or conflict
    static let instance = Repository()
    private init() {
        loadEventData()
    }
    
    // Fire event request, setting class events property
    // Once we have events we can trigger a series of requests for each event image,
    // as well as handling of likes and search strings
    func loadEventData() {
        let eventsRequest = EventsRequest()
        eventsRequest.getEvents { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let events):
                self?.events = events
                self?.loadImages(events: events)
                self?.setupLikes()
                self?.setupSearchStrings()
            }
        }
    }
    
    // Series of requests to obtain images for each event and cache them
    func loadImages(events: [Event]) {
        for event in events {
            if let imageUrl = event.performers.first?.image {
                let imageRequest = ImageRequest(resourceUrl: imageUrl)
                imageRequest.getImage { [weak self] result in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let image):
                        self?.imageCache.updateValue(image, forKey: event.id)
                        self?.checkComplete()
                    }
                }
            }
        }
    }
    
    // Check cache has been filled with images for each event
    // This feels a little hacky and I will work on improving this on my own
    func checkComplete() {
        if imageCache.count == events.count {
            
            // Once cache is filled, we can reload the table asynchronously on the main queue
            DispatchQueue.main.async {
                self.repoDelegate.loadAllEvents()
            }
        }
    }
    
    // Initialize appropriate like objects in Core Data
    // Prevents creation of duplicates, but will continue to accumulate old ids not in current events
    func setupLikes() {
        
        for event in events {
            
            // Create fetchRequest for each event, looking for like with matching id
            let request = Like.fetchRequest() as NSFetchRequest<Like>
            let predicate = NSPredicate(format: "id == %@", event.id.description)
            request.predicate = predicate
            
            // If a like for this event already exists in Core Data, continue loop
            if (try! context.fetch(request).first != nil) { continue }
            
            // Add new like corresponding to this event to context
            let like = Like(context: context)
            like.id = event.id
        }
        
        // Persist like data
        appDelegate.saveContext()
    }
    
    // Searching is simple when we can query a concatenated string representing the information for each event
    func setupSearchStrings() {
        for event in events {
            let date = Date.fromIso(event.datetime_utc)
            let searchString = (
                event.type +
                event.title +
                event.venue.city +
                event.venue.state +
                event.venue.name +
                date.dateString() +
                date.timeString()
            ).lowercased()
            searchStrings.updateValue(searchString, forKey: event.id)
        }
    }
    
    // Return filtered array of events based on query string
    func getFilteredEvents(query: String) -> [Event] {
        var output = [Event]()
        for event in events {
            if searchStrings[event.id]!.contains(query.lowercased()) {
                output.append(event)
            }
        }
        return output
    }
    
    // Toggle Like that matches given event's id and persist
    func toggleLike(event: Event) {
        let request = Like.fetchRequest() as NSFetchRequest<Like>
        let predicate = NSPredicate(format: "id == %@", event.id.description)
        request.predicate = predicate
        
        if let like = try? context.fetch(request).first {
            like.liked.toggle()
            appDelegate.saveContext()
        }
    }
    
    // Check to see the value of a given event's Like
    func isLiked(event: Event) -> Bool {
        let request = Like.fetchRequest() as NSFetchRequest<Like>
        let predicate = NSPredicate(format: "id == %@", event.id.description)
        request.predicate = predicate
        
        if let like = try? context.fetch(request).first {
            return like.liked
        }
        
        return false
    }
    
    // We want to keep events as a private property - we can access using this getter
    func getEvents() -> [Event] {
        return events
    }
    
    // Want to keep imageCache private - using this getter for access
    // More elegant as well
    func getImage(event: Event) -> UIImage {
        return imageCache[event.id]!
    }
}
