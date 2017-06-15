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
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = expenseBO.receiptId
        lblUploadeBy.text = expenseBO.name
        lblEmpId.text = expenseBO.id
        lblExpenseID.text = expenseBO.id
        let string = expenseBO.updated_at
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "MMM dd yyyy"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)

        lblUploadDate.text = dateString
        txtVwComment.text = expenseBO.status
        if expenseBO.validate == "0"
        {
            lblStatus.text = "Waiting for validation"
        }
        else if expenseBO.validate == "1"
        {
            if expenseBO.approved == "0"
            {
                lblStatus.text = "Waiting for approval"
            }
            else if expenseBO.approved == "1"
            {
                if expenseBO.status == "0"
                {
                    lblStatus.text = "Waiting for payment to be made"
                }
                else if expenseBO.status == "1"
                {
                    lblStatus.text = "Paid"
                }
                else if expenseBO.status == "2"
                {
                    lblStatus.text = "Rejected"
                }
            }
            else if expenseBO.approved == "2"
            {
                lblStatus.text = "Rejected"
            }
        }
        else if expenseBO.validate == "2"
        {
            lblStatus.text = "Rejected"
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
