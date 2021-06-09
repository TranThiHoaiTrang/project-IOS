
import UIKit

class HomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load data if you don't want to connect database:
        BooksManagement.loadData();
    }


}

