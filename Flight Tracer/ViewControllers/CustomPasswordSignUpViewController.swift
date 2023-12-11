//
//  CustomPasswordSignUpViewController.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 12/10/23.
//

import SwiftUI
import FirebaseEmailAuthUI

class CustomPasswordSignUpViewController: FUIPasswordSignUpViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("got here yo")
        let mainView = view.subviews[0]
        mainView.backgroundColor = Colors.NAVY_BLUE
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, authUI: FUIAuth, email: String?, requireDisplayName: Bool) {
       super.init(nibName: "FUIPasswordSignUpViewController",
                  bundle: nibBundleOrNil,
                  authUI: authUI,
                  email: email,
                  requireDisplayName: requireDisplayName)
    }

     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
     }
}

#Preview {
    ContentView()
}
