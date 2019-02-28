//
//  SplashVC.swift
//  Fameet
//
//  Created by Jansen Malvin on 28/02/19.
//  Copyright © 2019 Terretino. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    let userDefault = UserDefaults.standard
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if userDefault.bool(forKey: "usersignedin"){
            let homeViewController: UIViewController = UIStoryboard(name: "Feature", bundle: nil).instantiateViewController(withIdentifier: "HomeViewTab") as UIViewController
            present(homeViewController, animated: true)
        }
        else {
            let homeViewController: UIViewController = UIStoryboard(name: "UserManagement", bundle: nil).instantiateViewController(withIdentifier: "NavbarUserManagement") as UIViewController
            present(homeViewController, animated: true)
        }
    }
        


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
