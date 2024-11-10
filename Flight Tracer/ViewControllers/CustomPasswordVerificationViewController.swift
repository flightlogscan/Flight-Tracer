import SwiftUI
import FirebaseEmailAuthUI

class CustomPasswordVerificationViewController: FUIPasswordVerificationViewController {
    let gradient = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainView = view.subviews[0] as! UITableView
        mainView.isScrollEnabled = false
        
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
        
        //Any bounds related settings need to be updated here becase
        //bounds of the view aren't established until `viewWillLayoutSubviews`
        //gradient/label aren't added here because this method is called multiple times
        gradient.frame = view.bounds
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, authUI: FUIAuth, email: String?, newCredential: AuthCredential) {
        super.init(nibName: "FUIPasswordVerificationViewController", bundle: nibBundleOrNil, authUI: authUI, email: email, newCredential: newCredential)
      }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
