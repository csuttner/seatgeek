//
//  Events.swift
//  SeatGeek
//
//  Created by Clay Suttner on 1/28/21.
//

// Model for events api endpoint data in-memory store - not necessary to persist for expected functionality
// Only loading fields necessary for expected functionality, but more could easily be added here
// All decodable for easy JSON parsing

import Foundation
 
struct EventsResponse: Decodable {
    var events: [Event]
}

struct Event: Decodable {
    
    // Specify Int64 to align with Core Data allowed types
    var id: Int64
    var datetime_utc: String
    var venue: Venue
    var title: String
    var performers: [Performer]
    
    // This particular string seemed nice for searchbar queries
    var type: String
}

struct Venue: Decodable {
    var name: String
    var city: String
    var state: String
}

struct Performer: Decodable {
    var image: URL
}
