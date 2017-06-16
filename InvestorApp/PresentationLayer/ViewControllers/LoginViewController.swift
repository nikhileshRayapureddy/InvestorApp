//
//  LoginViewController.swift
//  InvestorApp
//
//  Created by NIKHILESH on 14/06/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit
let LOGIN_STATUS = "isAlreadyLogin"
class LoginViewController: UIViewController,ParserDelegate {

    @IBOutlet weak var btnRememberMe: UIButton!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPwd: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        txtFldEmail.text = "srikanth@taksykraft.com"
//        txtFldPwd.text = "TaksyKraft"
        // Do any additional setup after loading the view.
    }

    @IBAction func btnLogin(_ sender: UIButton) {
        app_delegate.showLoader(message: "")
        let bl = BusinessLayer()
        bl.callBack = self
        bl.doLoginWith(emailId: txtFldEmail.text!, pwd: txtFldPwd.text!)
    }
    func parsingFinished(_ object: AnyObject?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        DispatchQueue.main.async {
            
            if self.navigationController?.viewControllers.count == 1
            {
                let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let _ = self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    func parsingError(_ error: String?, withTag tag: NSInteger) {
        app_delegate.removeloder()
    }
    @IBAction func btnRememberMeClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected
        {
            UserDefaults.standard.set(true, forKey: LOGIN_STATUS)
        }
        else
        {
            UserDefaults.standard.set(false, forKey: LOGIN_STATUS)
        }
        UserDefaults.standard.synchronize()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
