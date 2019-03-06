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
    @IBOutlet weak var briefFameetLabel: UILabel!
    @IBOutlet weak var briefFameetExpLabel: UILabel!
    //MARK : INITIALIZER
    let userDefault = UserDefaults.standard
    
    func setupView() {
        //Label
        briefFameetLabel.animatingWithMovement(1)
        briefFameetExpLabel.animatingWithMovement(1.5)
        
        //Google Button
        googleButton.shappingButton()
        googleButton.animating(2)
        //Create Account
        createAccountButton.shappingButton()
        createAccountButton.animating(2)
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
    
    func setupViewAnimation() {
        googleButton.alpha = 0
        createAccountButton.alpha = 0
        briefFameetLabel.alpha = 0
        briefFameetExpLabel.alpha = 0
        briefFameetLabel.center.x = 0
        briefFameetExpLabel.center.x = 0
        
    }
    
    override func viewDidLoad() {
        setupViewAnimation()
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
