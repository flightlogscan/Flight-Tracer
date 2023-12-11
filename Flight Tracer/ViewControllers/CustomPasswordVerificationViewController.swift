//
//  CustomPasswordVerificationViewController.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 12/10/23.
//

import SwiftUI
import FirebaseEmailAuthUI

class CustomPasswordVerificationViewController: FUIPasswordVerificationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainView = view.subviews[0]
        mainView.backgroundColor = Colors.NAVY_BLUE
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, authUI: FUIAuth, email: String?, newCredential: AuthCredential) {
        super.init(nibName: "FUIPasswordVerificationViewController", bundle: nibBundleOrNil, authUI: authUI, email: email, newCredential: newCredential)
      }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
