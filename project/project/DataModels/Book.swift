
import Foundation;
import UIKit;

class Book {
    // MARK: Properties
    var bookID: Int;
    var bookName: String;
    var bookAuthors: String;
    var bookType: String;
    var bookQuantity: Int;
    var bookQuantityCurrent: Int;
    var bookImage: UIImage?;
    
    // MARK: Constructors
    init?(id: Int, name: String, authors: String, type: String, quantity: Int, quantityCurrent: Int, image: UIImage?) {
        if name.isEmpty == true || authors.isEmpty == true || type.isEmpty == true {
            return nil;
        }
        
        bookID = id;
        bookName = name;
        bookAuthors = authors;
        bookType = type;
        bookQuantity = quantity;
        bookQuantityCurrent = quantityCurrent;
        bookImage = image;
    }
    
    public static func toString() -> String {
        return "This is a book!";
    }
}
