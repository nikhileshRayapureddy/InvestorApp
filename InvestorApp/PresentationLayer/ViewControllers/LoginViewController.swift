//
//  LoginViewController.swift
//  InvestorApp
//
//  Created by NIKHILESH on 14/06/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,ParserDelegate {

    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPwd: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFldEmail.text = "srikanth@taksykraft.com"
        txtFldPwd.text = "TaksyKraft"
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
           let _ = self.navigationController?.popViewController(animated: true)
        }
        
    }
    func parsingError(_ error: String?, withTag tag: NSInteger) {
        app_delegate.removeloder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
