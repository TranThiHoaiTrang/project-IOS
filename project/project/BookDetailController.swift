import UIKit

class BookDetailController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Properties:
    enum NavigationType {
        case addNewBook
        case updateBook
    }
    var navigationType: NavigationType = .addNewBook;
    public var book: Book?;
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookID: UITextField!
    @IBOutlet weak var bookName: UITextField!
    @IBOutlet weak var bookAuthors: UITextField!
    @IBOutlet weak var bookTypes: UITextField!
    @IBOutlet weak var bookTotalQuantity: UITextField!
    @IBOutlet weak var bookCurrentQuantity: UITextField!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    // First load:
    override func viewDidLoad() {
        super.viewDidLoad();
        navigationItem.title = "Book's detail";
        
        // Delegation:
        bookID.delegate = self;
        bookName.delegate = self;
        bookAuthors.delegate = self;
        bookTypes.delegate = self;
        bookTotalQuantity.delegate = self;
        bookCurrentQuantity.delegate = self;
        
        // Get book to updated from BooksTableViewController if it exists:
        if let b = self.book {
            bookImage.image = b.bookImage;
            bookID.text = String(b.bookID);
            bookName.text = b.bookName;
            bookAuthors.text = b.bookAuthors;
            bookTypes.text = b.bookType;
            bookTotalQuantity.text = String(b.bookQuantity);
            bookCurrentQuantity.text = String(b.bookQuantityCurrent);
        }
    }
    
    // Methods:
    
    //MARK: Hiding keyboard after tap "done":
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    //MARK: Hiding keyboard:
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let str = textField.text {
            print("\(str)");
        }
    }
    
    // Cancel button:
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if navigationType == .addNewBook {
            dismiss(animated: true, completion: nil);
        }
        else if navigationType == .updateBook {
            navigationController?.popViewController(animated: true);
        }
    }
    
    // Change image:
    @IBAction func tapImage(_ sender: UITapGestureRecognizer) {
        print("Image is tapped!");
        // Get image from Photo library:
        let imagePicker = UIImagePickerController()
        // Config data soucre for the image picker:
        imagePicker.sourceType = .photoLibrary
        // Delegation:
        imagePicker.delegate = self
        // Show the image picker:
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Get image:
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            bookImage.image = selectedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender);
        if let btn = sender as?  UIBarButtonItem {
            if btn === btnSave {
                let id = Int(bookID.text ?? "0");
                let name = bookName.text ?? "";
                let authors = bookAuthors.text ?? "";
                let type = bookTypes.text ?? "";
                let quantity = Int(bookTotalQuantity.text ?? "0");
                let quantityCurrent = Int(bookCurrentQuantity.text ?? "0");
                let image = bookImage.image;

                self.book = Book(id: id!, name: name, authors: authors, type: type, quantity: quantity!, quantityCurrent: quantityCurrent!, image: image);
            }
        }
    }

}
