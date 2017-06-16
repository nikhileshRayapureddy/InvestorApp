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
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let indiaLocale = NSLocale(localeIdentifier: "en_IN")
            numberFormatter.locale = indiaLocale as Locale!
            let result = numberFormatter.string(from: Int(str)! as NSNumber)!

            self.lblTotalCost.text = "₹ \(result)"
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
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let indiaLocale = NSLocale(localeIdentifier: "en_IN")
        numberFormatter.locale = indiaLocale as Locale!
        let result = numberFormatter.string(from: Int(expenseBO.amount)! as NSNumber)!

        cell.lblPrice.text = "₹ \(result)"
        let string = expenseBO.created_at
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "MMM dd, yyyy"
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
            cell.lblStatus.textColor = UIColor(red: 255.0/255.0, green: 184.0/255.0, blue: 14.0/255.0, alpha: 1)
            cell.imgStatus.image = #imageLiteral(resourceName: "not")
        }
        else if expenseBO.validate == "1"
        {
            if expenseBO.approved == "0"
            {
                cell.lblStatus.text = "Waiting for approval"
                cell.imgStatus.image = #imageLiteral(resourceName: "not")
                cell.lblStatus.textColor = UIColor(red: 255.0/255.0, green: 184.0/255.0, blue: 14.0/255.0, alpha: 1)
            }
            else if expenseBO.approved == "1"
            {
                if expenseBO.status == "0"
                {
                    cell.lblStatus.text = "Waiting for payment to be made"
                    cell.imgStatus.image = #imageLiteral(resourceName: "not")
                    cell.lblStatus.textColor = UIColor(red: 255.0/255.0, green: 184.0/255.0, blue: 14.0/255.0, alpha: 1)
                }
                else if expenseBO.status == "1"
                {
                    cell.lblStatus.text = "Paid"
                    cell.imgStatus.image =  #imageLiteral(resourceName: "approved")
                    cell.lblStatus.textColor = UIColor(red: 125.0/255.0, green: 194.0/255.0, blue: 127.0/255.0, alpha: 1)
                }
                else if expenseBO.status == "2"
                {
                    cell.lblStatus.text = "Rejected"
                    cell.lblStatus.textColor = UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1)
                    cell.imgStatus.image = #imageLiteral(resourceName: "rej")
                }
            }
            else if expenseBO.approved == "2"
            {
                cell.lblStatus.text = "Rejected"
                cell.imgStatus.image = #imageLiteral(resourceName: "rej")
                cell.lblStatus.textColor = UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1)
            }
        }
        else if expenseBO.validate == "2"
        {
            cell.lblStatus.text = "Rejected"
            cell.imgStatus.image = #imageLiteral(resourceName: "rej")
            cell.lblStatus.textColor = UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1)
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
    
    @IBAction func btnLogoutClicked(_ sender: UIButton) {
        if self.navigationController?.viewControllers.count == 1
        {
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

