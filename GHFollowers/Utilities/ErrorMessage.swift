//
//  GHError.swift
//  GHFollowers
//
//  Created by Burkay Atar on 4.01.2024.
//

import Foundation


enum GHError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data recieved from the server is invalid. Please try again."
}
