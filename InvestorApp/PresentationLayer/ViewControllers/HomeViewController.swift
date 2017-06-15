//
//  ViewController.swift
//  InvestorApp
//
//  Created by NIKHILESH on 14/06/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit
let imagePath = "https://s3-ap-southeast-1.amazonaws.com/taksykraft/bills/"
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
        let expenseBO = arrExpenses[indexPath.row]
        cell.lblName.text = expenseBO.name
        cell.lblDesc.text = expenseBO.Description
        cell.lblPrice.text = "₹ \(expenseBO.amount)"
        let string = expenseBO.created_at
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "MMM dd yyyy"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)

        cell.lblDate.text = dateString
        cell.lblReceiptId.text = expenseBO.receiptId
        
        var strImage = imagePath + expenseBO.image
        strImage = strImage.replacingOccurrences(of: "\r", with: " ")
        strImage = strImage.replacingOccurrences(of: "\n", with: " ")
        let safeURL = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string:safeURL!)
        if expenseBO.validate == "0"
        {
            cell.lblStatus.text = "Waiting for validation"
        }
        else if expenseBO.validate == "1"
        {
            if expenseBO.approved == "0"
            {
                cell.lblStatus.text = "Waiting for approval"
            }
            else if expenseBO.approved == "1"
            {
                if expenseBO.status == "0"
                {
                    cell.lblStatus.text = "Waiting for payment to be made"
                }
                else if expenseBO.status == "1"
                {
                    cell.lblStatus.text = "Paid"
                }
                else if expenseBO.status == "2"
                {
                    cell.lblStatus.text = "Rejected"
                }
            }
            else if expenseBO.approved == "2"
            {
                cell.lblStatus.text = "Rejected"
            }
        }
        else if expenseBO.validate == "2"
        {
            cell.lblStatus.text = "Rejected"
        }

        
        cell.imgVw.kf.indicatorType = .activity
        cell.imgVw.kf.setImage(with: url ,
                               placeholder: nil,
                               options: [.transition(ImageTransition.fade(1))],
                               progressBlock: { receivedSize, totalSize in
        },
                               completionHandler: { image, error, cacheType, imageURL in
        })

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExpensesDetailViewController") as! ExpensesDetailViewController
        vc.expenseBO = arrExpenses[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: false)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

