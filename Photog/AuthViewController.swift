//
//  AuthViewController.swift
//  Photog
//
//  Created by One Month on 9/7/14.
//  Copyright (c) 2014 One Month. All rights reserved.
//

import UIKit
import SwiftHTTP

enum AuthMode
{
    case SignIn
    case SignUp
}

class AuthViewController: UIViewController, UITextFieldDelegate {

    var authMode: AuthMode = AuthMode.SignUp
    
    @IBOutlet var emailTextField: UITextField?
    @IBOutlet var passwordTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        var emailImageView = UIImageView(frame: CGRectMake(0, 0, 50, self.emailTextField!.frame.size.height))
        emailImageView.image = UIImage(named: "EmailIcon")
        emailImageView.contentMode = .Center
        
        self.emailTextField!.leftView = emailImageView
        self.emailTextField!.leftViewMode = .Always
        
        var passwordImageView = UIImageView(frame: CGRectMake(0, 0, 50, self.passwordTextField!.frame.size.height))
        passwordImageView.image = UIImage(named: "PasswordIcon")
        passwordImageView.contentMode = .Center
        
        self.passwordTextField!.leftView = passwordImageView
        self.passwordTextField!.leftViewMode = .Always
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.emailTextField?.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
        
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if (textField == self.emailTextField)
        {
            self.emailTextField?.resignFirstResponder()
            self.passwordTextField?.becomeFirstResponder()
        }
        else if (textField == self.passwordTextField)
        {
            self.passwordTextField?.resignFirstResponder()
            
            self.authenticate()
        }
        
        return true
    }
    
    func authenticate()
    {
        var email = self.emailTextField?.text
        var password = self.passwordTextField?.text
        
        if (email?.isEmpty == true || password?.isEmpty == true || email?.isEmailAddress() == false) // is this an email address
        {
            self.showAlert("Please check your email address and password")
            
            return
        }
        
        if authMode == .SignIn
        {
            self.signIn(email!, password: password!)
        }
        else
        {
            self.signUp(email!, password: password!)
        }
    }
    
    func signIn(email: String, password: String)
    {
        var request = HTTPTask()
        //we have to add the explicit type, else the wrong type is inferred. See the vluxe.io article for more info.
        let params: Dictionary<String,AnyObject> = ["user_session": ["email": email, "password": password]]
        request.POST("http://theworldnearby.com/user_sessions.json", parameters: params, success: {(response: HTTPResponse) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var tabBarController = TabBarController()
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                })
            },failure: {(error: NSError, response: HTTPResponse?) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.showAlert("Sign in failure, check your credentials and try again.")
                })
        })
    }
    
    func signUp(email: String, password: String)
    {
        var request = HTTPTask()
        //we have to add the explicit type, else the wrong type is inferred. See the vluxe.io article for more info.
        let params: Dictionary<String,AnyObject> = ["user": ["name": email, "email": email, "password": password]]
        request.POST("http://theworldnearby.com/customusers.json", parameters: params, success: {(response: HTTPResponse) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var tabBarController = TabBarController()
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                })
            },failure: {(error: NSError, response: HTTPResponse?) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.showAlert("Sign up failure!")
                })
        })
    }
}
