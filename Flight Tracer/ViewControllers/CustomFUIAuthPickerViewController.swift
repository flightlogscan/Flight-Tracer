//
//  CustomFUIAuthPickerViewController.swift
//  Flight Tracer
//
//  Created by Wilbur 😎 on 12/7/23.
//

import FirebaseAuthUI
import SwiftUI

class CustomFUIAuthPickerViewController : FUIAuthPickerViewController {
    
    let NAVY_BLUE = UIColor(red: 0.0, green: 0.2, blue: 0.5, alpha: 1.0)
    let GOLD = UIColor(red: 0.84, green: 0.69, blue: 0.21, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainBackground = view.subviews[0]
        mainBackground.backgroundColor = NAVY_BLUE
        
        createAirplaneLogo()
        
        let buttonTray = mainBackground.subviews[0]

        buttonTray.backgroundColor = .black
        buttonTray.layer.cornerRadius = 40.0
        buttonTray.translatesAutoresizingMaskIntoConstraints = false
        
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
        imageView.tintColor = GOLD
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
