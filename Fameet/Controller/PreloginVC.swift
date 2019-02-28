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
    
    func setupView() {
        //Google Button
        googleButton.shappingButton()
        
        //Create Account
        createAccountButton.shappingButton()
        
        //NavBar design
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
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

    @IBAction func signInAct(_ sender: Any) {
        performSegue(withIdentifier: "Prelogin-Login", sender: self)
    }

}
