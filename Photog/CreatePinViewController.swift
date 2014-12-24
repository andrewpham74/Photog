//
//  CreatePinViewController.swift
//  TheWorldNearby
//
//  Created by xxx on 12/7/14.
//  Copyright (c) 2014 One Month. All rights reserved.
//

import UIKit
import SwiftHTTP

class CreatePinViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var image : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitPin() {
        var request = HTTPTask()
        //we have to add the explicit type, else the wrong type is inferred. See the vluxe.io article for more info.
        
        let params: Dictionary<String,AnyObject> = ["pin": ["description": self.descriptionTextField.text, "image": HTTPUpload(data: UIImagePNGRepresentation(image!), fileName: "image", mimeType: "image/png")]]
        request.POST("http://theworldnearby.com/pins.json", parameters: params, success: {(response: HTTPResponse) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            },failure: {(error: NSError, response: HTTPResponse?) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.showAlert("Could not submit pin, please make sure all fields are filled in")
                })
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if (textField == self.descriptionTextField)
        {
            self.submitPin()
        }
        
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
