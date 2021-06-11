//
//  GettingBookBackViewController.swift
//  project
//
//  Created by Ling on 6/9/21.
//  Copyright © 2021 tranthihoaitrang. All rights reserved.
//

import UIKit

class GettingBookBackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // Properties:
    var readerBooks = [ReaderBooks]();
    var borrowedBooks = [Book]();
    var isValid_readerID: Bool = false;
    var isValid_borrowingID: Bool = false;
    var isValid_quantity: Bool = false;
    
    @IBOutlet weak var readerID: UITextField!
    @IBOutlet weak var borrowingID: UITextField! // This is ID of readerBooks.
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var booksTableView: UITableView!
    @IBOutlet weak var message: UILabel!
    
    
    // First load:
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Reader returns book";
        btnSubmit.backgroundColor = UIColor.init(red: 0/255, green: 130/255, blue: 200/255, alpha: 1.0);
        btnSubmit.setTitleColor(UIColor.white, for: .normal);
        
        // Delegation:
        self.booksTableView.delegate = self;
        self.booksTableView.dataSource = self;
    }
    
    // Methods:
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil);
    }
    
    
    // Text changed:
    @IBAction func readerIDChanged(_ sender: Any) {
        borrowingID.text = "";
        quantity.text = "";
        
        var count: Int = 0;
        for r in ReadersManagement.readers {
            if r.readerID == Int(readerID.text ?? "") {
                count = count + 1;
                break;
            }
        }
        if count == 0 {
            isValid_readerID = false;
            message.text = "Reader ID doesn't exist!";
            message.textColor = UIColor.red;
            // Reload tableView:
            readerBooks = [];
            borrowedBooks = [];
            booksTableView.reloadData();
        }
        else {
            isValid_readerID = true;
            message.text = "";
            // Load readerBooks and borrowedBooks:
            readerBooks = [];
            borrowedBooks = [];
            for rb in ReaderBooksManagement.readerBooks {
                if Int(readerID.text ?? "") == rb.readerID {
                    if let b = BooksManagement.getBookByID(id: rb.bookID) {
                        self.readerBooks.append(rb);
                        self.borrowedBooks.append(b);
                    }
                }
            }
            booksTableView.reloadData();
        }
    }
    
    @IBAction func borrowingIDChanged(_ sender: Any) {
        var count: Int = 0;
        for rb in ReaderBooksManagement.readerBooks {
            if rb.readerbooksID == Int(borrowingID.text ?? "") && rb.readerID == Int(readerID.text ?? "") {
                count = count + 1;
                break;
            }
        }
        if count == 0 {
            if readerID.text == "" {
                isValid_borrowingID = false;
                message.text = "Please choose a reader!";
                message.textColor = UIColor.red;
                // Reload tableView:
                readerBooks = [];
                borrowedBooks = [];
                booksTableView.reloadData();
            }
            else {
                isValid_borrowingID = false;
                message.text = "Borrowing ID doesn't exist!";
                message.textColor = UIColor.red;
                if borrowingID.text == "" {
                    readerBooks = [];
                    borrowedBooks = [];
                    for rb in ReaderBooksManagement.readerBooks {
                        if Int(readerID.text ?? "") == rb.readerID {
                            if let b = BooksManagement.getBookByID(id: rb.bookID) {
                                self.readerBooks.append(rb);
                                self.borrowedBooks.append(b);
                            }
                        }
                    }
                    booksTableView.reloadData();
                }
                else {
                    // Reload tableView:
                    readerBooks = [];
                    borrowedBooks = [];
                    booksTableView.reloadData();
                }
            }
        }
        else {
            isValid_borrowingID = true;
            message.text = "";
            // Load readerBooks and borrowedBooks:
            readerBooks = [];
            borrowedBooks = [];
            for rb in ReaderBooksManagement.readerBooks {
                if Int(borrowingID.text ?? "") == rb.readerbooksID {
                    if let b = BooksManagement.getBookByID(id: rb.bookID) {
                        self.readerBooks.append(rb);
                        self.borrowedBooks.append(b);
                    }
                }
            }
            booksTableView.reloadData();
        }
    }
    
    @IBAction func quantityChanged(_ sender: Any) {
        if let q = Int(quantity.text ?? "0") {
            if borrowedBooks.count == 1 && readerBooks.count == 1 {
                if readerBooks[0].quantity < q {
                    isValid_quantity = false;
                    message.text = "Quantity cannot be greater than \(readerBooks[0].quantity)!";
                    message.textColor = UIColor.red;
                }
                else {
                    isValid_quantity = true;
                    message.text = "";
                }
            }
            else {
                isValid_quantity = false;
                message.text = "Please choose a reader and a book!";
                message.textColor = UIColor.red;
            }
        }
        else {
            isValid_quantity = false;
            message.text = "Invalid quantity value!";
            message.textColor = UIColor.red;
        }
    }
    
    
    // Submit:
    @IBAction func submit(_ sender: Any) {
        if isValid_readerID == true {
            if borrowingID.text == "" && quantity.text == "" {
                // READER RETURN ALL BOOKS:
                // Before removing, update book quantity of BooksManagement.books:
                for rb in ReaderBooksManagement.readerBooks {
                    if rb.readerID == Int(readerID.text ?? "") {
                        for b in BooksManagement.books {
                            if b.bookID == rb.bookID {
                                b.bookQuantityCurrent = b.bookQuantityCurrent + rb.quantity;
                            }
                        }
                    }
                }
                
                // Remove item from ReaderBooksManagement.readerBooks:
                var indexToBeRemoved = [Int]();
                var count = 0;
                for i in 0...ReaderBooksManagement.readerBooks.count-1 {
                    if ReaderBooksManagement.readerBooks[i].readerID == Int(readerID.text ?? "") {
                        indexToBeRemoved.append(i - count);
                        count = count + 1;
                    }
                }
                for i in indexToBeRemoved {
                    ReaderBooksManagement.readerBooks.remove(at: i);
                }
                
                // Reload tableView:
                readerBooks = [];
                borrowedBooks = [];
                booksTableView.reloadData();
                
                // Show message:
                message.text = "Get all book back successfully!";
                message.textColor = UIColor.green;
                print("Get all book back successfully");
            }
            else if borrowingID.text != "" && quantity.text != "" {
                // READER RETURN ONE BOOK:
            }
        }
        else {
            isValid_readerID = false;
            message.text = "Please choose a reader!";
            message.textColor = UIColor.red;
        }
    }
    
    
    
    
    
    // TableView:
    // (Import: UITableViewDataSource, UITableViewDelegate).
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.borrowedBooks.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.booksTableView.dequeueReusableCell(withIdentifier: "SuggestGettingTableViewCell", for: indexPath) as? SuggestGettingTableViewCell {
            
            let b = self.borrowedBooks[indexPath.row];
            let rb = self.readerBooks[indexPath.row];
            cell.bookID.text = String(b.bookID);
            cell.bookName.text = b.bookName;
            cell.bookQuantity.text = String(rb.quantity);
            cell.bookImage.image = b.bookImage;
            cell.borrowingID.text = String(rb.readerbooksID);
            
            return cell;
        }
        else {
            fatalError("Cannot create cell!");
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
