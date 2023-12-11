//
//  CustomEmailEntryViewController.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 12/9/23.
//

import SwiftUI
import FirebaseEmailAuthUI

class CustomEmailEntryViewController : FUIEmailEntryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainView = view.subviews[0] as! UIScrollView
        mainView.isScrollEnabled = false
        mainView.backgroundColor = Colors.NAVY_BLUE
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Sign in flow navigation color only needs to be set once for the entire
        // navigation flow. No need to revert in viewWillDisappear because future screens use a different
        // NavigationController.
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    // Unclear why, but view crashes if these aren't here.
    override init(nibName: String?, bundle: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIEmailEntryViewController", bundle: bundle, authUI: authUI)
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// Keeping in. Helpful for discovery of firebase auth ui views
//extension UIView {
//    func findViews<T: UIView>(subclassOf: T.Type) -> [T] {
//        return recursiveSubviews.compactMap { $0 as? T }
//    }
//
//    var recursiveSubviews: [UIBarItem] {
//        print("willy" + self.description)
//        print("sv count: \(self.subviews.count)")
//        print("=========================")
//        return subviews + subviews.flatMap { $0.recursiveSubviews }
//    }
//}

#Preview {
    ContentView()
}
