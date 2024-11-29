import FirebaseAuthUI
import SwiftUI

// Override values in FUIAuthPickerViewController to make custom auth picker
// This will help understand how to modify the ViewController
// Reference FUIAuthPickerViewController.m to see initial structure
class CustomAuthPickerViewController : FUIAuthPickerViewController {
    
    let gradient = CAGradientLayer()
    let logoLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = view.subviews[0] as! UIScrollView
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        
        //Add gradient and logo here so they are only drawn once
        gradient.colors = [UIColor(Color.navyBlue).cgColor, UIColor.white]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 1, y: 1)
        scrollView.layer.insertSublayer(gradient, at: 0)
        
        createLogoText()
                
        let buttonTray = scrollView.subviews[0]

        buttonTray.backgroundColor = .black
        buttonTray.layer.cornerRadius = 40.0
        
        
        // Only top left and right corners of view are rounded
        buttonTray.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let buttonContainerView = buttonTray.subviews[0]
        let screenHeight = UIScreen.main.bounds.height

        // Check if the device is an iPhone SE (1st, 2nd, or 3rd generation)
        if screenHeight <= 667 { // iPhone SE (1st Gen: 568, 2nd/3rd Gen: 667)
            buttonContainerView.frame.size = CGSize(width: 300, height: 100)
        } else {
            buttonContainerView.frame.size = CGSize(width: 300, height: 150)
        }
        for each in buttonContainerView.subviews {
            if let providerButton = each as? UIButton {
                providerButton.frame.origin.x -= 9
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
        super.viewWillLayoutSubviews()
        //Any bounds related settings need to be updated here becase
        //bounds of the view aren't established until `viewWillLayoutSubviews`
        //gradient/label aren't added here because this method is called multiple times
        //so they would get drawn multiple times
        gradient.frame = view.subviews[0].bounds
        logoLabel.center = view.center
    }
    
    private func createLogoText() {
        logoLabel.text = "Flight Log Tracer"
        logoLabel.textColor = .white
        logoLabel.font = UIFont(name: "Magnolia Script", size: 40)
        logoLabel.sizeToFit()
        
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
