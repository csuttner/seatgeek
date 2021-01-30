//
//  EventsRequest.swift
//  SeatGeek
//
//  Created by Clay Suttner on 1/28/21.
//

// Class manages retreival of event data

import Foundation

class EventsRequest {
    let resourceUrl: URL
    
    init() {
        
        // Set resource to be equal to endpoint with client id and client secret parameters passed in from Authentication
        let resourceString = "https://api.seatgeek.com/2/events?client_id=\(Authorization.clientId)&client_secret=\(Authorization.clientSecret)"
        guard let resourceUrl = URL(string: resourceString) else { fatalError() }
        self.resourceUrl = resourceUrl
    }
    
    // Asynchronously obtain data from endpoint, parsing JSON to array of events
    // Return simple errors for either no data or inability to process
    func getEvents(completion: @escaping(Result<[Event], RequestError>) -> ()) {
        
        // Only need the data parameter in the URLSession completion handler
        let dataTask = URLSession.shared.dataTask(with: resourceUrl) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let eventsResponse = try decoder.decode(EventsResponse.self, from: jsonData)
                let events = eventsResponse.events
                completion(.success(events))
            } catch {
                completion(.failure(.cantProcessData))
            }
            
        }
        dataTask.resume()
    }
    
}
