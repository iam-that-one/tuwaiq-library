//
//  BooksViewModel.swift
//  Library
//
//  Created by Abdullah Alnutayfi on 14/03/2021.
//

import Foundation
import SwiftUI

class BooksViewModel: ObservableObject {
    @Published var books : [Book] = [Book(id: UUID().uuidString, title: "Zero to One", author: "Peter Thiel", price: 45.0, quantity: 12, image: "Zero to One", image2: nil),
                                     Book(id: UUID().uuidString, title: "You don't know JS", author: "Kyle Simpson", price: 39.9, quantity: 9, image: "You don't know JS", image2: nil),
                                     Book(id:  UUID().uuidString, title: "But how do it know", author: "J. Clark Scott", price: 59.9, quantity: 22, image: "But how do it know", image2: nil),
                                     Book(id: UUID().uuidString, title: "Clean Code", author: "Robert Cecil Martin", price: 50.0, quantity: 5, image: "Clean Code", image2: nil),
                                     Book(id: UUID().uuidString, title: "Start with why", author: "Simon Sinek", price: 80.0, quantity: 13, image: "Start with why", image2: nil)]
    
     var cartItems = [Book]()
    @Published var cart = 0
     var totalAdded : Int{
         cart
     }
    @Published var totalprice = 0.0
    var totalPrice: Double{
        totalprice
    }
    func add(book : Book) {
        cartItems.append(book)
    }
}

struct Book : Identifiable {
    var id = UUID().uuidString
    var title = ""
    var author = ""
    var price : Double?
    var quantity : Int?
    var image : String?
    var image2 : UIImage?
}
