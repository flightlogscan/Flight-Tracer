//
//  CustomEmailEntryViewController.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 12/9/23.
//

import SwiftUI
import FirebaseEmailAuthUI

class CustomEmailEntryViewController : FUIEmailEntryViewController {
    
    let NAVY_BLUE = UIColor(red: 0.0, green: 0.2, blue: 0.5, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = view.subviews[0] as! UITableView
        tableView.backgroundColor = NAVY_BLUE
   
        //Need a better way of doing this sorta hacky
        //I think this changes ALL UIBar and navbar items to white regardless of view
        UIBarButtonItem.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
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
    ContentView()
}
