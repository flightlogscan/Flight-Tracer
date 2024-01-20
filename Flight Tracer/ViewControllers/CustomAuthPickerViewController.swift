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
        
        scrollView.isScrollEnabled = false
        createAirplaneLogo()
        
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
    
    private func createAirplaneLogo() {
        let image = UIImage(systemName: "airplane")
        let imageView = UIImageView(image: image!)
        imageView.tintColor = Colors.GOLD
        imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        imageView.center = view.center
        view.subviews[0].addSubview(imageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

#Preview {
    ContentView()
}
