//
//  PreloginVC.swift
//  FinalChallengeVessel
//
//  Created by Christian Limansyah on 01/02/19.
//  Copyright © 2019 Terretino. All rights reserved.
//


import UIKit


class PreloginVC: UIViewController {
    
    //MARK : OUTLET
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    //MARK : INITIALIZER
    let userDefault = UserDefaults.standard
    
    
    
    func setupView() {
        //Google Button
        googleButton.shappingButton()
        
        //Create Account
        createAccountButton.shappingButton()
//        createAccountButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        createAccountButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.5)
//        createAccountButton.layer.shadowOpacity = 0.8
//        createAccountButton.layer.shadowRadius = 0.0
//        createAccountButton.layer.masksToBounds = false
//        createAccountButton.layer.cornerRadius = 4.0
        
        //NavBar design
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "usersignedin"){
            showHomeController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        setupView()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func showHomeController() {
        let homeViewController: UIViewController = UIStoryboard(name: "Feature", bundle: nil).instantiateViewController(withIdentifier: "HomeViewTab") as UIViewController
        present(homeViewController, animated: true)
    }

    @IBAction func signInAct(_ sender: Any) {
        performSegue(withIdentifier: "Prelogin-Login", sender: self)
    }

}
