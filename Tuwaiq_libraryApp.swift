//
//  Tuwaiq_libraryApp.swift
//  Tuwaiq-library
//
//  Created by Abdullah Alnutayfi on 27/03/2021.
//

import SwiftUI

@main
struct Tuwaiq_libraryApp: App {
    var book = BooksViewModel()
    var body: some Scene {
        
        WindowGroup {
            ContentView(book_img0: nil,PickedImage: UIImage()).environmentObject(book)
        }
    }
}
