//
//  CustomPasswordSignInViewController.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 12/10/23.
//

import SwiftUI
import FirebaseEmailAuthUI

class CustomPasswordSignInViewController: FUIPasswordSignInViewController {
    
    let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainView = view.subviews[0] as! UITableView
        mainView.isScrollEnabled = false
        
        let button = mainView.subviews[0].subviews[0] as? UIButton
        button?.setTitleColor(UIColor.white, for: UIControl.State.normal)

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
        
        // Remove "Sign in" navigation from login page
        navigationItem.title = nil
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
