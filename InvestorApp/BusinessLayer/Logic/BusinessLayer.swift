//
//  BusinessLayer.swift
//  UrDoorStep
//
//  Created by Nikhilesh on 26/09/16.
//  Copyright © 2016 Capillary. All rights reserved.
//

import UIKit
let NO_INTERNET = "No Internet Access. Check your network and try again."



let SERVER_ERROR = "Server not responding.\nPlease try after some time."

let CONTENT_LENGTH = "Content-Length"
let CONTENT_TYPE  = "Content-Type"


var shoppingListSelected : Int = 0

let app_delegate =  UIApplication.shared.delegate as! AppDelegate

let NoInternet : NSString = "There seems to be some data connectivity issue with your network. Please check connection and try again."
let ScreenWidth : CGFloat =  UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.height

let developer_API = "http://188.166.218.149/api/v1/"
class BusinessLayer: BaseBL {
    //MARK: Supporting Methods
    func doLoginWith(emailId : String,pwd:String)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.getLogin.rawValue)
        obj.MethodNamee = "GET"
        obj._serviceURL = developer_API + "login"
        var dataDict = [String:AnyObject]()
        dataDict["email"] = emailId as AnyObject?
        dataDict["password"] = pwd as AnyObject?
        obj.params = dataDict
        
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let error = obj.parsedDataDict["error"] as? String
                {
                    if Bool(error) == false
                    {
                        if let data = obj.parsedDataDict["data"] as? [[String:AnyObject]]
                        {
                            if data.count > 0
                            {
                                let userBo = UserBO()
                                for user in data
                                {
                                    if let user_id = user["id"] as? String
                                    {
                                        userBo.user_id = user_id
                                    }
                                    if let name = user["name"] as? String
                                    {
                                        userBo.name = name
                                    }
                                    if let email = user["email"] as? String
                                    {
                                        userBo.email = email
                                    }
                                    if let role = user["role"] as? String
                                    {
                                        userBo.role = role
                                    }
                                    if let created_at = user["created_at"] as? String
                                    {
                                        userBo.created_at = created_at
                                    }
                                    if let updated_at = user["updated_at"] as? String
                                    {
                                        userBo.updated_at = updated_at
                                    }
                                }
                                self.callBack.parsingFinished(userBo as AnyObject, withTag: obj.tag)
                            }
                            else
                            {
                                self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                            }
                            
                        }
                        else
                        {
                            self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                            
                        }
                        
                    }
                    else
                    {
                        self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                        
                    }
                }
            }
        }

    }
    func getExpenses()
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.getExpenses.rawValue)
        obj.MethodNamee = "GET"
        obj._serviceURL = developer_API + "expenses"
        obj.params = [:]
        
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let isSuccess  = obj.parsedDataDict["error"] as? String
                {
                    if Bool(isSuccess) == false
                    {
                        var dict = [String:AnyObject]()
                        if let totalAmount = obj.parsedDataDict["totalAmount"] as? String
                        {
                            dict["totalAmount"] = totalAmount as AnyObject?
                        }
                        if let data = obj.parsedDataDict["data"] as? [[String:AnyObject]]
                        {
                            var arrExpenses = [ExpensesBO]()
                            for expense in data
                            {
                                let expensesBO = ExpensesBO()
                                if let id = expense["id"] as? NSNumber
                                {
                                    expensesBO.id = String(Int(id))
                                }
                                if let receiptId = expense["receiptId"] as? String
                                {
                                    expensesBO.receiptId = receiptId
                                }
                                if let image = expense["image"] as? String
                                {
                                    expensesBO.image = image
                                }
                                if let name = expense["name"] as? String
                                {
                                    expensesBO.name = name
                                }
                                if let uploadedby = expense["uploadedby"] as? String
                                {
                                    expensesBO.uploadedby = uploadedby
                                }
                                if let amount = expense["amount"] as? String
                                {
                                    expensesBO.amount = amount
                                }
                                if let description = expense["description"] as? String
                                {
                                    expensesBO.Description = description
                                }
                                if let validate = expense["validate"] as? String
                                {
                                    expensesBO.validate = validate
                                }
                                if let approved = expense["approved"] as? String
                                {
                                    expensesBO.approved = approved
                                }
                                if let status = expense["status"] as? String
                                {
                                    expensesBO.status = status
                                }
                                if let created_at = expense["created_at"] as? String
                                {
                                    expensesBO.created_at = created_at
                                }
                                if let updated_at = expense["updated_at"] as? String
                                {
                                    expensesBO.updated_at = updated_at
                                }

                                arrExpenses.append(expensesBO)
                            }
                            dict["Expenses"] = arrExpenses as AnyObject?

                        }
                        self.callBack?.parsingFinished(dict as AnyObject?, withTag: obj.tag)
                    }
                    else
                    {
                        self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                    }
                }
                else
                {
                    self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
                }
            }
        }
        
    }

    func encodeSpecialCharactersManually(_ strParam : String)-> String
    {
        
        var strParams = strParam.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
        strParams = strParams!.replacingOccurrences(of: "&", with:"%26")
        return strParams!
    }
    
    func convertSpecialCharactersFromStringForAddress(_ strParam : String)-> String
    {
        
        var strParams = strParam.replacingOccurrences(of: "&", with:"&amp;")
        strParams = strParams.replacingOccurrences(of: ">", with: "&gt;")
        strParams = strParams.replacingOccurrences(of: "<", with: "&lt;")
        strParams = strParams.replacingOccurrences(of: "\"", with: "&quot;")
        strParams = strParams.replacingOccurrences(of: "'", with: "&apos;")
        return strParams
    }

}
