//
//  CustomFUIAuthPickerViewController.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 12/7/23.
//

import FirebaseAuthUI
import SwiftUI

// Override values in FUIAuthPickerViewController to make custom auth picker
// This will help understand how to modify the ViewController
// Reference FUIAuthPickerViewController.m to see initial structure
class CustomAuthPickerViewController : FUIAuthPickerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = view.subviews[0] as! UIScrollView
        scrollView.isScrollEnabled = false
        scrollView.backgroundColor = Colors.NAVY_BLUE
        scrollView.showsVerticalScrollIndicator = false
                
        let buttonTray = scrollView.subviews[0]

        buttonTray.backgroundColor = .black
        buttonTray.layer.cornerRadius = 40.0
        
        // Only top left and right corners of view are rounded
        buttonTray.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let buttonContainerView = buttonTray.subviews[0]
        for each in buttonContainerView.subviews {
            if let providerButton = each as? UIButton {
                providerButton.frame.origin.x -= 50
                providerButton.frame.size = CGSizeMake(320.0, 45.0)
                providerButton.layer.cornerRadius = 10.0
                providerButton.layer.backgroundColor = UIColor.darkGray.cgColor
                providerButton.layer.masksToBounds = true
                providerButton.setTitleColor(.white, for: .normal)
                providerButton.titleLabel?.textAlignment = .center
                
                var configuration = UIButton.Configuration.filled()
                configuration.baseBackgroundColor = .darkGray

                providerButton.configuration = configuration
                providerButton.contentHorizontalAlignment = .center
                providerButton.titleLabel?.font = .boldSystemFont(ofSize: 12)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()

        createLogoText()
    }
    
    private func createLogoText() {
        let logoLabel = UILabel()
        logoLabel.text = "Flight Log Tracer"
        logoLabel.textColor = .white
        logoLabel.font = UIFont(name: "Magnolia Script", size: 40)
        logoLabel.sizeToFit()
        
        logoLabel.center = view.center
        view.addSubview(logoLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Remove "Welcome" navigation from login page
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Keep Navigation bar on sign up page
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

#Preview {
    ContentView()
}
