//
//  AuthViewController.swift
//  Photog
//
//  Created by One Month on 9/7/14.
//  Copyright (c) 2014 One Month. All rights reserved.
//

import UIKit

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
            // alert the user (homework)

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
        PFUser.logInWithUsernameInBackground(email, password: password) {
            (user: PFUser!, error: NSError!) -> Void in
            
            if let constUser = user
            {
                var tabBarController = TabBarController()
                self.navigationController?.pushViewController(tabBarController, animated: true)
            }
            else
            {
                println("sign in failure! (alert the user)")
            }
        }
    }
    
    func signUp(email: String, password: String)
    {
        var user = PFUser()
        user.username = email
        user.email = email
        user.password = password
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            
            if let constError = error
            {
                println("sign up failure! (alert the user)")
                return
            }
            
            // New user follows him/herself
            NetworkManager.sharedInstance.follow(user, completionHandler: {
                (error) -> () in
                
                if let constError = error
                {
                    println("Unable for user to follow themself")
                    return
                }

                var tabBarController = TabBarController()
                self.navigationController?.pushViewController(tabBarController, animated: true)
                
            })
        }
    }    
}
