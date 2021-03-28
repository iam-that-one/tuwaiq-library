//
//  ContentView.swift
//  Library
//
//  Created by Abdullah Alnutayfi on 14/03/2021.
//

import SwiftUI

struct ContentView: View {
   // @State var catrItems = [Book]()
    
 //   init(){
  //      UINavigationBar.appearance().barTintColor = .white
   // }
    
    @EnvironmentObject var bvm : BooksViewModel
    @State var title = ""
    @State var author = ""
    @State var price = "0.0"
    @State var quantity = "0"
    @State var show_detiles = false
    @State var searchById = ""
    @State var searchByName = ""
    @State var searchByAuthName = ""
    @State var showSheet = false
    @State var showActionSheet = false
    @State var showImagePicker = false
    @State var book_img : Image?
  
    @State var PickedImage : UIImage
    @State var sourceType:UIImagePickerController.SourceType = .camera
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Image(systemName: "magnifyingglass")
                    TextField("Book Id",text: $searchById)
                    Divider()
                        .frame(height: 30)
                    
                    
                    TextField("Book Name",text: $searchByName)
                    
                    Divider()
                        .frame(height: 30)
                    
                    
                    TextField("Auther",text: $searchByAuthName)
                    
                    Button(action: {showSheet.toggle()}){
                        Text("+")
                            .font(Font.system(size: 20, weight: .bold, design: .default))
                            .foregroundColor(.black)
                    }.sheet(isPresented: $showSheet, content: {
                        VStack{
                            Text("Add New Book")
                            TextField("Book title", text: $title)
                            TextField("Author", text: $author)
                            TextField("price", text: $price)
                            TextField("remaining books", text: $quantity)
                            VStack{
                                if book_img != nil{
                                    book_img!
                                        .resizable()
                                        .frame(width: 300, height: 450, alignment: .center)
                                        .foregroundColor(.green)
                                    
                                }
                                else{
                                    
                                    Image(systemName: "text.below.photo.fill")
                                        
                                        .resizable()
                                        
                                        .scaledToFit()
                                        .padding()
                                        .frame(width: 200, height: 190)
                                        .padding()
                                        .clipShape(Circle())
                                        .foregroundColor(Color(.systemGreen))
                                        .opacity(0.90)
                                }
                            }
                            .onTapGesture {
                                showActionSheet.toggle()
                            }.actionSheet(isPresented: $showActionSheet, content: {
                                ActionSheet(title: Text("Choose a photo"), message: nil, buttons:
                                                [
                                                    .default(Text("Camera")){showImagePicker.toggle();sourceType = .camera},
                                                    .default(Text("Photo library")){showImagePicker.toggle();sourceType = .photoLibrary},
                                                    .cancel()
                                                ])
                            }
                            ).sheet(isPresented: $showImagePicker,onDismiss: loadImage, content: {
                                ImagePicker(sourceType: sourceType, selectedImage: $PickedImage)
                            })
                            Spacer()
                            Button("Add Book"){
                             
                                bvm.books.append(Book(id: UUID().uuidString, title: title, author: author , price: Double(price) , quantity: Int(quantity), image: nil , image2: PickedImage))
                                book_img = nil
                                title = ""
                                price = "0.0"
                                quantity = "0"
                                author = ""
                                showSheet = false
                             
                                
                            }
                            Spacer()
                        }.padding()
                    })
                }.padding(5)
                
                ScrollView{
                    VStack{
                        if searchByName == "" && searchById == "" && searchByAuthName == ""{
                            ForEach(bvm.books) { book in
                                if book.image != nil{
                                    Image(book.image!)
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width - 70, height: 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .shadow(color: .black,radius: 10)
                                        .scaledToFill()
                                }
                                
                              else  if book.image2 != nil{
                                Image(uiImage:book.image2!)
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width - 70, height: 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .shadow(color: .black,radius: 10)
                                    .scaledToFill()
                                }
                                HStack{
                                    Spacer()
                                    VStack{
                                        HStack{
                                            Text(book.title)
                                                .fontWeight(.bold)
                                            Text("by: " + book.author)
                                                .font(Font.system(size: 10, weight: .bold, design: .default))
                                        }
                                        Text("ID: \(book.id)")
                                            .font(Font.system(size: 12, weight: .bold, design: .default))
                                    }
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("Price: $\(book.price ?? 0, specifier: "%.2f")")
                                    Spacer()
                                    Text("lefted: \(book.quantity ?? 0)")
                                }
                                
                                Button(action: {
                                        bvm.add(book: book)
                                        print(bvm.cartItems)
                                        bvm.cart = bvm.cart + 1}){
                                    Spacer()
                                    Image(systemName: "cart.badge.plus")
                                        
                                        .foregroundColor(.red)
                                }
                                Divider()
                                    .padding(.bottom)
                                NavigationLink(
                                    destination: Cart(), isActive: $show_detiles){
                                    Text("Cart")
                                }.hidden()
                                
                            }
                        }else if searchByName != "" && searchById == "" && searchByAuthName == ""{
                            ForEach(bvm.books.filter({$0.title.lowercased().contains(searchByName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))})) { book in
                                if book.image != nil{
                                    Image("\(book.image!)")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width - 70, height: 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .shadow(color: .black,radius: 10)
                                        .scaledToFill()
                                }else{
                                    Image(uiImage:book.image2!)
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width - 70, height: 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .shadow(color: .black,radius: 10)
                                        .scaledToFill()
                                }
                                HStack{
                                    Spacer()
                                    VStack{
                                        HStack{
                                            Text(book.title)
                                                .fontWeight(.bold)
                                            Text("by: " + book.author)
                                                .font(Font.system(size: 10, weight: .bold, design: .default))
                                        }
                                        Text("ID: \(book.id)")
                                            .font(Font.system(size: 12, weight: .bold, design: .default))
                                    }
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("Price: $\(book.price ?? 0, specifier: "%.2f")")
                                    Spacer()
                                    Text("lefted: \(book.quantity ?? 0)")
                                }
                                
                                Button(action: {
                                        bvm.add(book: book)
                                        print(bvm.cartItems)
                                        bvm.cart = bvm.cart + 1}){
                                    Spacer()
                                    Image(systemName: "cart.badge.plus")
                                        
                                        .foregroundColor(.red)
                                }
                                Divider()
                                    .padding(.bottom)
                                NavigationLink(
                                    destination: Cart(), isActive: $show_detiles){
                                    Text("Cart")
                                }.hidden()
                                
                            }
                        }else if searchByName == "" && searchById != "" && searchByAuthName == ""{
                            ForEach(bvm.books.filter({$0.id.lowercased().contains(searchById.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))})) { book in
                                if book.image != nil{
                                    Image("\(book.image!)")
                                        .resizable()
                            
                                        .frame(width: UIScreen.main.bounds.width - 70, height: 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .shadow(color: .black,radius: 10)
                                        .scaledToFill()
                                }else{
                                    Image(uiImage:book.image2!)
                                        .resizable()
                                       
                                        .frame(width: UIScreen.main.bounds.width - 70, height: 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .shadow(color: .black,radius: 10)
                                        .scaledToFill()
                                }
                                HStack{
                                    Spacer()
                                    VStack{
                                        HStack{
                                            Text(book.title)
                                                .fontWeight(.bold)
                                            Text("by: " + book.author)
                                                .font(Font.system(size: 10, weight: .bold, design: .default))
                                        }
                                        Text("ID: \(book.id)")
                                            .font(Font.system(size: 12, weight: .bold, design: .default))
                                    }
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("Price: $\(book.price ?? 0, specifier: "%.2f")")
                                    Spacer()
                                    Text("lefted: \(book.quantity ?? 0)")
                                }
                                
                                Button(action: {
                                        bvm.add(book: book)
                                        print(bvm.cartItems)
                                        bvm.cart = bvm.cart + 1}){
                                    Spacer()
                                    Image(systemName: "cart.badge.plus")
                                        
                                        .foregroundColor(.red)
                                }
                                Divider()
                                    .padding(.bottom)
                                NavigationLink(
                                    destination: Cart(), isActive: $show_detiles){
                                    Text("Cart")
                                }.hidden()
                                
                            }
                        }else if searchByName == "" && searchById == "" && searchByAuthName != ""{
                            ForEach(bvm.books.filter({$0.author.lowercased().contains(searchByAuthName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))})) { book in
                                if book.image != nil{
                                    Image("\(book.image!)")
                                        .resizable()
                                        
                                        .frame(width: UIScreen.main.bounds.width - 70, height: 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .shadow(color: .black,radius: 10)
                                        .scaledToFill()
                                }else{
                                    Image(uiImage:book.image2!)
                                        .resizable()
                                    
                                        .frame(width: UIScreen.main.bounds.width - 70, height: 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .shadow(color: .black,radius: 10)
                                        .scaledToFill()
                                }
                                HStack{
                                    Spacer()
                                    VStack{
                                        HStack{
                                            Text(book.title)
                                                .fontWeight(.bold)
                                            Text("by: " + book.author)
                                                .font(Font.system(size: 10, weight: .bold, design: .default))
                                        }
                                        Text("ID: \(book.id)")
                                            .font(Font.system(size: 12, weight: .bold, design: .default))
                                    }
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("Price: $\(book.price ?? 0, specifier: "%.2f")")
                                    Text(book.author)
                                    Text("lefted: \(book.quantity ?? 0)")
                                }
                                
                                Button(action: {
                                    bvm.add(book: book)
                                    print(bvm.cartItems)
                                    // bvm.cart = bvm.cart + 1
                                    
                                }){
                                    Spacer()
                                    Image(systemName: "cart.badge.plus")
                                        
                                        .foregroundColor(.red)
                                }
                                Divider()
                                    .padding(.bottom)
                                NavigationLink(
                                    destination: Cart(), isActive: $show_detiles){
                                    Text("Cart")
                                }.hidden()
                                
                            }
                        }
                        
                        // // // // // // // // // // // // // // // // // // // // //
                    }.padding()
                    
                    //.onAppear {
                    //        UITableView.appearance().tintColor = .clear
                    // }
                }
                Spacer()
            }.navigationBarTitle(Text("Library"),displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                show_detiles.toggle()
                
                
            }){
                HStack{
                    Circle()
                        .overlay(Text("\(bvm.totalAdded)")
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red))
                        .padding()
                        .clipShape(Circle())
                        .frame(width: 20, height: 20, alignment: .center)
                        
                        
                        
                        .offset(x: 5)
                    Image(systemName: "cart")
                        .foregroundColor(.black)
                    
                    
                }
                
            })
            
        }
    }
    func loadImage()
    {
        book_img = Image(uiImage: PickedImage)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(PickedImage: UIImage())
    }
}

struct Cart : View {
   // @Binding var Passedimage : UIImage
    @EnvironmentObject var bv : BooksViewModel
   
    @State var checkOut = false
    var body: some View{
        ZStack{
            VStack{
                List{
                    ForEach(bv.cartItems) { item in
                        VStack(alignment: .leading){
                            
                            HStack{
                                if let img = item.image{
                                    Image("\(img)")
                                        .resizable()
                                        .frame(width: 30, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                }
                                
                                else if item.image == nil{
                                    Image(uiImage:item.image2!)
                                        .resizable()
                                        .frame(width: 30, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                }
                               
                                VStack(alignment: .leading){
                                    Text(item.title)
                                        .font(Font.system(size: 14, weight: .bold, design: .rounded))
                                    Text("By: " + item.author)
                                        .font(Font.system(size: 10, design: .rounded))
                                    Text("\(item.quantity!) lefted")
                                        .font(Font.system(size: 10, design: .serif))
                                        .foregroundColor(.red)
                                }
                                Spacer()
                                Text("Price: $\(item.price! , specifier:  "%.2f")")
                                    .font(Font.system(size: 10, design: .serif))
                                    .foregroundColor(.red)
                            }//.background(Color(.systemGray5))
                            
                        }.padding()
                        
                        .navigationBarTitle(Text("Manage your cart"))
                    }.onDelete(perform: { indexSet in
                        bv.cartItems.remove(atOffsets: indexSet)
                        bv.cart = bv.cart - 1
                    })
                    
            
                    
                }
                Button(action:{
                    checkOut.toggle()
                    bv.totalprice = 0.0
                    for i in bv.cartItems{
                        bv.totalprice = bv.totalprice + i.price!
                    }
                }){
                    Text("Check out")
                        .frame(width: UIScreen.main.bounds.width, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding()
                        .background(bv.cart == 0 ? Color(.systemGray5) : Color.blue)
                        .foregroundColor(bv.cart == 0 ? .gray: .white)
                    
                } .disabled(bv.cart == 0 ? true : false)
                NavigationLink(destination: CheckOut(), isActive: $checkOut ){
                    Text("")
                }.hidden()
                
            }
            if bv.cartItems.count == 0{
                
                Image(systemName: "cart")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.gray)
                //  .offset(y:50)
                Text("Empty")
                    .foregroundColor(.gray)
                    .offset(y:50)
            }
        }
    }
}
struct  CheckOut : View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var bv : BooksViewModel
    let paymentTypes = ["Cash","Credit Card","Customer Points"]
    @State private var paymentType = 0
    @State private var Credit_Card_Number = ""
    @State private var name = ""
    @State private var cvc = ""
    @State private var exp_date = ""
    @State private var alertSheet = false
    @State private var rec = false
    @State private var moveToLibrary = false
    var body: some View{
        VStack{
            List{
            ForEach(bv.cartItems){item in
               
                VStack(alignment: .leading){
                    HStack{
                        if let img = item.image{
                            Image("\(img)")
                                .resizable()
                                .frame(width: 30, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        else{
                            Image(uiImage:item.image2!)
                                .resizable()
                                .frame(width: 30, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        VStack(alignment: .leading){
                            Text(item.title)
                                .font(Font.system(size: 14, weight: .bold, design: .rounded))
                            Text("By: " + item.author)
                                .font(Font.system(size: 10, design: .rounded))
                            Text("\(item.quantity!) lefted")
                                .font(Font.system(size: 10, design: .serif))
                                .foregroundColor(.red)
                        }
                        Spacer()
                        
                        Text("Price: $\(item.price! , specifier:  "%.2f")")
                            .font(Font.system(size: 10, design: .serif))
                            .foregroundColor(.red)
                    }//.background(Color(.systemGray5))
                    
                }.padding()
                
                .navigationBarTitle(Text("Manage your cart"))
            }
        }
            Form{
                Section{
                    VStack{
                        Picker("How do you want to pay?",selection: $paymentType){
                            ForEach(0 ..< self.paymentTypes.count){
                                Text(self.paymentTypes[$0])
                            }
                        }
                        if paymentType == 1{
                            TextField("Card Number", text: $Credit_Card_Number.animation())
                                .keyboardType(.numberPad)
                            TextField("Name As On the Card", text: $name.animation())
                            HStack{
                                TextField("Exp. date", text: $exp_date.animation())
                                    .keyboardType(.numberPad)
                                Spacer()
                                TextField("CVC", text: $cvc.animation())
                                    .keyboardType(.numberPad)
                            }
                        }
                        
                    }
                }
                Text("TOTAL: $\(bv.totalprice, specifier: "%.2f")")
                Button(action:{alertSheet.toggle()}){
                    HStack{
                        Spacer()
                        Text("Confirm")
                            .frame(width: UIScreen.main.bounds.width - 40, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(5)
                            .offset(x: -20)
                        
                        Spacer()
                    }
                }.alert(isPresented: $alertSheet, content: {
                    Alert(title: Text("Conformation"), message: Text("Your request has done!"), primaryButton: .default(Text("view receipt")){
                        rec.toggle()
                        
                    }, secondaryButton: .default(Text("Ok")){
                        alertSheet = false
                        bv.cartItems = []
                        presentationMode.wrappedValue.dismiss()
                        bv.cart = 0
                        // moveToLibrary.toggle()
                    })
                })
                
            }.sheet(isPresented: $rec, content: {
                Text("Items")
                    .padding(.top)
                ZStack{
                    Circle()
                        .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(.systemGray5))
                        .overlay(
                            Text("Tuwaiq library")
                                .foregroundColor(Color(.systemGray5))
                                .background(Color.white)
                                .rotationEffect(.degrees(45))
                        )
                    HStack{
                        
                        
                        Spacer()
                    }.padding(.horizontal)
                    VStack(alignment: .trailing){
                        
                        ForEach(bv.cartItems) {item in
                            HStack{
                                Text(item.title)
                                    .font(Font.system(size: 12, design: .monospaced))
                                Spacer()
                                Text("$\(item.price!, specifier: "%.2f")")
                                    .font(Font.system(size: 12, design: .monospaced))
                                
                            }
                        }
                        HStack{
                            Spacer()
                        Text("+++++++++++++++++++++++++++++++++++++++++++++++++")
                            .font(Font.system(size: 12, design: .monospaced))
                            .multilineTextAlignment(.center)
                            Spacer()
                        }
                          
                        Text("TOTAL: $\(bv.totalprice, specifier: "%.2f")")
                            .font(Font.system(size: 12, design: .monospaced))
                        Text("Paid by: \(self.paymentTypes[paymentType])")
                            .font(Font.system(size: 12, design: .monospaced))
                        Spacer()
                        Button(action:{
                            presentationMode.wrappedValue.dismiss()
                            bv.cartItems = []
                            rec = false
                            bv.cart = 0
                        }){
                            Text("Done")
                                .frame(width: 60, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                        }
                        HStack{
                            Text("Tuwaiq library")
                                .font(Font.system(size: 14, weight: .bold, design: .serif))
                            Image(systemName: "books.vertical.fill")
                        }
                        
                    }.padding(.horizontal)
                }
            })
            
            Spacer()
            
        }.navigationBarTitle(Text("Check out"),displayMode: .inline)
    }
}
