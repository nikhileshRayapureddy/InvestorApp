//
//  ExpensesDetailViewController.swift
//  InvestorApp
//
//  Created by Nikhilesh on 15/06/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit

class ExpensesDetailViewController: UIViewController {
    var expenseBO = ExpensesBO()
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblUploadeBy: UILabel!
    @IBOutlet weak var lblEmpId: UILabel!
    @IBOutlet weak var lblExpenseID: UILabel!
    @IBOutlet weak var lblUploadDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var txtVwComment: UITextView!
    var fortVw : ImageDetailPopUp!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = expenseBO.receiptId
        lblUploadeBy.text = expenseBO.name
        lblEmpId.text = expenseBO.id
        lblExpenseID.text = expenseBO.receiptId
        txtVwComment.text = expenseBO.Description
        let string = expenseBO.created_at
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)

        lblUploadDate.text = dateString
        if expenseBO.validate == "0"
        {
            lblStatus.text = "Waiting for validation"
            lblStatus.textColor = UIColor(red: 255.0/255.0, green: 184.0/255.0, blue: 14.0/255.0, alpha: 1)
        }
        else if expenseBO.validate == "1"
        {
            if expenseBO.approved == "0"
            {
                lblStatus.text = "Waiting for approval"
                lblStatus.textColor = UIColor(red: 255.0/255.0, green: 184.0/255.0, blue: 14.0/255.0, alpha: 1)
            }
            else if expenseBO.approved == "1"
            {
                if expenseBO.status == "0"
                {
                    lblStatus.text = "Waiting for payment to be made"
                    lblStatus.textColor = UIColor(red: 255.0/255.0, green: 184.0/255.0, blue: 14.0/255.0, alpha: 1)
                }
                else if expenseBO.status == "1"
                {
                    lblStatus.text = "Paid"
                    lblStatus.textColor = UIColor(red: 125.0/255.0, green: 194.0/255.0, blue: 127.0/255.0, alpha: 1)
                }
                else if expenseBO.status == "2"
                {
                    lblStatus.text = "Rejected"
                    lblStatus.textColor = UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1)
                }
            }
            else if expenseBO.approved == "2"
            {
                lblStatus.text = "Rejected"
                lblStatus.textColor = UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1)
            }
        }
        else if expenseBO.validate == "2"
        {
            lblStatus.text = "Rejected"
            lblStatus.textColor = UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1)
        }


        var strImage = imagePath + expenseBO.image
        strImage = strImage.replacingOccurrences(of: "\r", with: " ")
        strImage = strImage.replacingOccurrences(of: "\n", with: " ")
        let safeURL = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string:safeURL!)

        imgVw.kf.indicatorType = .activity
        imgVw.kf.setImage(with: url ,
                               placeholder: nil,
                               options: [.transition(ImageTransition.fade(1))],
                               progressBlock: { receivedSize, totalSize in
        },
                               completionHandler: { image, error, cacheType, imageURL in
        })


        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrlVw.contentSize = CGSize(width: ScreenWidth, height: 600)
    }
    @IBAction func btnBackClicked(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnImgClicked(_ sender: UIButton) {
        fortVw   =   (Bundle.main.loadNibNamed("ImageDetailPopUp", owner: nil, options: nil)![0] as? ImageDetailPopUp)!
        fortVw.lblRecipetID.text = lblTitle.text
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let indiaLocale = NSLocale(localeIdentifier: "en_IN")
        numberFormatter.locale = indiaLocale as Locale!
        let result = numberFormatter.string(from: Int(expenseBO.amount)! as NSNumber)!

        fortVw.lblPrice.text = "₹ " + result
        var strImage = imagePath + expenseBO.image
        strImage = strImage.replacingOccurrences(of: "\r", with: " ")
        strImage = strImage.replacingOccurrences(of: "\n", with: " ")
        let safeURL = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string:safeURL!)
        
        fortVw.imgReceipt.kf.indicatorType = .activity
        fortVw.imgReceipt.kf.setImage(with: url ,
                          placeholder: nil,
                          options: [.transition(ImageTransition.fade(1))],
                          progressBlock: { receivedSize, totalSize in
        },
                          completionHandler: { image, error, cacheType, imageURL in
        })
        

        fortVw?.frame = CGRect(x:0,y: 0,width: ScreenWidth, height:ScreenHeight)
        fortVw.btnClose.addTarget(self, action: #selector(btnCloseClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(fortVw!)

        
    }
    func btnCloseClicked(sender : UIButton)
    {
        fortVw.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
