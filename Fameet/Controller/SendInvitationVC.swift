//
//  SendMassageViewController.swift
//  SyncToiCal
//
//  Created by Eka Pratista Wijaya on 29/01/19.
//  Copyright © 2019 Eka Pratista Wijaya. All rights reserved.
//

import UIKit
import MessageUI

class SendInvitationVC: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    var MasterFamily = String()
    
    //outlet
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var familyName: UILabel!
    @IBOutlet weak var linkFamilyGroup: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    
    
    
    //action
    
    //email
    @IBAction func sendEmailButton(_ sender: Any) {
        let mailCompose = MFMailComposeViewController()
        mailCompose.mailComposeDelegate =  self
        mailCompose.setToRecipients(["\(emailField.text!)"])
        mailCompose.setSubject("Invitation to \(familyName.text!)")
        mailCompose.setMessageBody(" Hello MR/MS \(userName.text!) invite you to Join \(MasterFamily) click here to join \(linkFamilyGroup.text!) ", isHTML: false)
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailCompose, animated: true, completion: nil)
        }
        else
        {
            print("!!!!!")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //messages
    @IBAction func sendMessagesButton(_ sender: Any) {
        if MFMessageComposeViewController.canSendText(){
            let controller = MFMessageComposeViewController()
            controller.body = " Hello MR/MS \(userName.text!) invite you to Join \(familyName.text!) click here to join \(linkFamilyGroup.text!) "
            controller.recipients = ["\(phoneNumberField.text!)"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }else {
            print("cannot send text messages")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
