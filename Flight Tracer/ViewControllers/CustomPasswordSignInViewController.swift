//
//  CustomPasswordSignInViewController.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 12/10/23.
//

import SwiftUI
import FirebaseEmailAuthUI

class CustomPasswordSignInViewController: FUIPasswordSignInViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainView = view.subviews[0] as! UIScrollView
        mainView.isScrollEnabled = false
        mainView.backgroundColor = Colors.NAVY_BLUE
        
        let button = mainView.subviews[0].subviews[0] as? UIButton
        button?.setTitleColor(UIColor.white, for: UIControl.State.normal)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, authUI: FUIAuth, email: String?) {
        super.init(nibName: "FUIPasswordSignInViewController", bundle: nibBundleOrNil, authUI: authUI, email: email)
      }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

#Preview {
    ContentView()
}
