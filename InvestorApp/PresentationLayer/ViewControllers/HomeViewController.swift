//
//  ViewController.swift
//  InvestorApp
//
//  Created by NIKHILESH on 14/06/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ParserDelegate {
    @IBOutlet weak var tblExpenses: UITableView!
    @IBOutlet weak var lblTotalCost: UILabel!

    var arrExpenses = [ExpensesBO]()
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        // Do any additional setup after loading the view, typically from a nib.
        
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        self.navigationController?.pushViewController(vc, animated: false)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        app_delegate.showLoader(message: "")
        let bl = BusinessLayer()
        bl.callBack = self
        bl.getExpenses()

    }
    func parsingFinished(_ object: AnyObject?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        DispatchQueue.main.async {
            let dict = object as! [String:AnyObject]
            self.arrExpenses = dict["Expenses"] as! [ExpensesBO]
            let str = dict["totalAmount"] as! String
            self.lblTotalCost.text = "₹ \(str)"
            self.tblExpenses.reloadData()
        }
        
    }
    func parsingError(_ error: String?, withTag tag: NSInteger) {
        app_delegate.removeloder()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrExpenses.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ExpensesCustomCell", for: indexPath) as! ExpensesCustomCell
        let bo = arrExpenses[indexPath.row]
        cell.lblName.text = bo.name
        cell.lblDesc.text = bo.Description
        cell.lblPrice.text = "₹ \(bo.amount)"
        cell.lblDate.text = bo.created_at
        cell.lblReceiptId.text = bo.receiptId
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

