//
//  CustomFUIAuthPickerViewController.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 12/7/23.
//

import FirebaseAuthUI
import SwiftUI

class CustomAuthPickerViewController : FUIAuthPickerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainBackground = view.subviews[0] as! UIScrollView
        mainBackground.isScrollEnabled = false
        mainBackground.backgroundColor = Colors.NAVY_BLUE
        
        mainBackground.isScrollEnabled = false
        createAirplaneLogo()
        
        let buttonTray = mainBackground.subviews[0]

        buttonTray.backgroundColor = .black
        buttonTray.layer.cornerRadius = 40.0
        
        // Only top left and right corners of view are rounded
        buttonTray.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let buttonsParent = buttonTray.subviews[0]
        for each in buttonsParent.subviews {
            if let button = each as? UIButton {
                button.layer.cornerRadius = 10.0
                button.layer.backgroundColor = UIColor.darkGray.cgColor
                button.layer.masksToBounds = true
                button.setTitleColor(.white, for: .normal)
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
