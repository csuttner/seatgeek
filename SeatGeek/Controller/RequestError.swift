//
//  RequestError.swift
//  SeatGeek
//
//  Created by Clay Suttner on 1/29/21.
//

// Simple request error options - in the future this could be expanded to include a timeout case

import Foundation

enum RequestError: Error {
    case noDataAvailable
    case cantProcessData
}
