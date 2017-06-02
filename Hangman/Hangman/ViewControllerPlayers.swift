import UIKit

class ViewControllerPlayers: UIViewController {

    @IBOutlet weak var riddleTextView: UITextField!
    override func viewDidLoad() {super.viewDidLoad()}
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! GameViewControllerPlayers
        dest.riddleWord = riddleTextView.text!
        
    }
}
