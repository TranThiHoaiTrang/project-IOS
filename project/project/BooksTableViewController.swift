//
//  BooksTableViewController.swift
//  project
//
//  Created by Ling on 6/4/21.
//  Copyright © 2021 tranthihoaitrang. All rights reserved.
//

import UIKit

class BooksTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    // Properties:
    enum NavigationType {
        case addNewBook
        case updateBook
    }
    var navigationType: NavigationType = .addNewBook;
    
//    var bookList = [Book]()
//    var searchBook = [Book]()
    let bookList = [Book]()
    var filerData:[Book]!
    // First load:
    override func viewDidLoad() {
        super.viewDidLoad();
        filerData = BooksManagement.books
        setUpSearchBar()
        // self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.title = "Books";
        self.navigationItem.rightBarButtonItems?.append(editButtonItem);
        
    }
    
    // Methods:
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil);
    }
    func setUpSearchBar(){
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        guard !searchText.isEmpty else{
//            searchBook = bookList
//            self.tableView.reloadData()
//            return
//        }
//        searchBook = bookList.filter(
//            {(book)->Bool in book.bookName.lowercased().contains(searchText.lowercased())}
//        )
        
        filerData = []
        if searchText == ""{
            filerData = BooksManagement.books
        }
        else{
            for book in BooksManagement.books{
                if book.bookName.lowercased().contains(searchText.lowercased()){
                    filerData.append(book)
                }
                
            }
        }
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filerData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BooksTableViewCell", for: indexPath) as? BooksTableViewCell {
            
            let book = filerData[indexPath.row];
            cell.bookImage.image = book.bookImage;
            cell.bookName.text = book.bookName;
            cell.bookAuthors.text = book.bookAuthors;
            cell.bookQuantity.text = String(book.bookQuantity);
            cell.bookQuantityCurrent.text = String(book.bookQuantityCurrent);
            return cell;
        }
        else {
            fatalError("Cannot create BooksTableViewCell!");
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            filerData.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: .fade);
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
