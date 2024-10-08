//
//  CustomEmailEntryViewController.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 12/9/23.
//

import SwiftUI
import FirebaseEmailAuthUI

class CustomEmailEntryViewController : FUIEmailEntryViewController {
    
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
        
        //Keeping in. Helpful for discovery of firebase auth ui views
//        let foundViews: [UIScrollView] = self.view.findViews(subclassOf: UIScrollView.self)
//        print(foundViews.count)
//        for scrollView in foundViews {
//            print(scrollView)
//        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Any bounds related settings need to be updated here becase
        //bounds of the view aren't established until `viewWillLayoutSubviews`
        //gradient/label aren't added here because this method is called multiple times
        //so they would get drawn multiple times
        gradient.frame = view.bounds
        
        // Sign in flow navigation color only needs to be set once for the entire
        // navigation flow. No need to revert in viewWillDisappear because future screens use a different
        // NavigationController.
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.layer.sublayers = nil
    }
    
    // Unclear why, but view crashes if these aren't here.
    override init(nibName: String?, bundle: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIEmailEntryViewController", bundle: bundle, authUI: authUI)
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

#Preview {
    ContentView(user: nil, isLoggedIn: nil)
}

 //Keeping in. Helpful for discovery of firebase auth ui views
//extension UIView {
//    func findViews<T: UIView>(subclassOf: T.Type) -> [T] {
//        return recursiveSubviews.compactMap { $0 as? T }
//    }
//
//    var recursiveSubviews: [UIView] {
//        // Get all subviews recursively
//        return subviews + subviews.flatMap { $0.recursiveSubviews }
//    }
//}
