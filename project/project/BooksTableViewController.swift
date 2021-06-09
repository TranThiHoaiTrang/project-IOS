import UIKit

class BooksTableViewController: UITableViewController {
    // Properties:
    enum NavigationType {
        case addNewBook
        case updateBook
    }
    var navigationType: NavigationType = .addNewBook;
    
    // First load:
    override func viewDidLoad() {
        super.viewDidLoad();

        // self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.title = "Books";
        self.navigationItem.rightBarButtonItems?.append(editButtonItem);
    }
    
    // Methods:
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil);
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return BooksManagement.books.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BooksTableViewCell", for: indexPath) as? BooksTableViewCell {
            
            let book = BooksManagement.books[indexPath.row];
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
            BooksManagement.books.remove(at: indexPath.row);
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

    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender);

        if let segueName = segue.identifier {
            let destinationController = segue.destination as? BookDetailController

            if segueName == "AddNewBookSegue" {
                navigationType = .addNewBook;
                // Set navigationType of destination:
                if destinationController != nil {
                    destinationController?.navigationType = .addNewBook;
                }
            }
            else if segueName == "UpdateBookSegue" {
                navigationType = .updateBook;
                var b: Book? = nil;
                if let selectedRow = tableView.indexPathForSelectedRow?.row {
                    print(">> Selected row: \(selectedRow)")
                    b = BooksManagement.books[selectedRow];
                }
                // Set navigationType of destination:
                if destinationController != nil {
                    destinationController!.book = b!;
                    destinationController?.navigationType = .updateBook;
                }
            }
        }
        else {
            print("You must define identifier for segue!")
        }
    }
    
    @IBAction func unwind_toBooks(sender: UIStoryboardSegue) {
        if let sourceController = sender.source as? BookDetailController,
            let b = sourceController.book {
            
            // Indentify route:
            if navigationType == .addNewBook {
                let newIndexPath = IndexPath(row: BooksManagement.books.count, section: 0)
                BooksManagement.books.append(b);
                tableView.insertRows(at: [newIndexPath], with: .none);
            }
            else if navigationType == .updateBook {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    BooksManagement.books[selectedIndexPath.row] = b;
                    tableView.reloadRows(at: [selectedIndexPath], with: .automatic);
                }
            }
        }
    }
}
