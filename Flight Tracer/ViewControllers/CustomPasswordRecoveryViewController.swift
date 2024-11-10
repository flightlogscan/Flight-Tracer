import SwiftUI
import FirebaseEmailAuthUI

class CustomPasswordRecoveryViewController: FUIPasswordRecoveryViewController {
    let gradient = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainView = view.subviews[0] as! UITableView
        mainView.isScrollEnabled = false
        
        let footerTextView = self.value(forKey: "footerTextView") as! UITextView
        footerTextView.textColor = .white  // Change to desired color
        
        
        //Add gradient and logo here so they are only drawn once
        gradient.colors = [Colors.NAVY_BLUE!.cgColor, UIColor.white]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let backgroundView = UIView(frame: mainView.bounds)
        backgroundView.layer.insertSublayer(gradient, at: 0)
        
        mainView.backgroundView = backgroundView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Sign in flow navigation color only needs to be set once for the entire
        // navigation flow. No need to revert in viewWillDisappear because future screens use a different
        // NavigationController.
        gradient.frame = view.bounds
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, authUI: FUIAuth, email: String?) {
        super.init(nibName: "FUIPasswordRecoveryViewController", bundle: nibBundleOrNil, authUI: authUI, email: email)
      }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
