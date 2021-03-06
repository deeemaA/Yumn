//
//  HospitalProfileViewController.swift
//  Yumn
//
//  Created by Deema Almutairi on 19/02/2022.
//

import SCLAlertView
import Foundation
import FirebaseFirestore
import FirebaseAuth
import UIKit
import SwiftUI

class HospitalProfileViewController: UIViewController, UITextFieldDelegate {
    let style = styles()
    let database = Firestore.firestore()
    let blue = UIColor.init(red: 134/255, green: 202/255, blue: 195/255, alpha: 1)
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var hospitalTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var nameErrorMSG: UILabel!
    @IBOutlet weak var phoneErrorMSG: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
        
        // Read Data
        profileInfo()
        
        //Hide
        saveButton(enabeld: false)
        hideErrorMSGs()
        
        // Hide keyboard
        self.hideKeyboardWhenTappedAround()
        
        guard let customFont = UIFont(name: "Tajawal", size: 19) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        saveButton.setAttributedTitle(NSAttributedString(string: "حفظ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]), for: .normal)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        nav?.tintColor = UIColor.white
        nav?.barTintColor = UIColor.init(named: "mainDark")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        nav?.tintColor = UIColor.init(named: "mainDark")
        nav?.barTintColor = UIColor.init(named: "mainDark")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "mainDark")!, NSAttributedString.Key.font: customFont]
    }
    
    func profileInfo(){
        let user = Auth.auth().currentUser
        let uid = user?.uid


        // get the Doc
        let docRef = database.collection("hospitalsInformation").document(uid!)
    
        // 2. to get live data
        docRef.addSnapshotListener { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }
            
            guard let hospitalName = data["name"] as? String else {
                return
            }
            guard let phone = data["phone"] as? String else {
                return
            }
            
            DispatchQueue.main.async {
                // Assign the values here
                self?.hospitalTextField.text = hospitalName
                self?.phoneTextField.text = phone
                
            }
        }
    }
    
    func setUP(){
        backView.layer.cornerRadius = 45
        saveButton.layer.cornerRadius = 45
        style(TextField: hospitalTextField)
        style(TextField: phoneTextField)
    }
    
    func saveButton(enabeld : Bool){
        saveButton.isEnabled = enabeld
        if(!enabeld){
            saveButton.layer.cornerRadius = 29
            saveButton.layer.backgroundColor = UIColor.lightGray.cgColor
        }
    }
    
    func hideErrorMSGs(){
        nameErrorMSG.isHidden = true
        phoneErrorMSG.isHidden = true
    }
    
    func style(TextField : UITextField){
        TextField.delegate = self
        normalStyle(TextField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        style.activeModeStyle(TextField: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        normalStyle(textField)
    }
    
    func normalStyle(_ TextField : UITextField){
        style.normalStyle(TextField: TextField)
    }
    
    func activeStyle(_ TextField : UITextField){
        style.activeModeStyle(TextField: TextField)
    }
    
    func turnTextFieldTextfieldToRed(_ textfield: UITextField){
        style.turnTextFieldToRed(textfield: textfield)
    }
    
    @IBAction func hospitalNameChanged(_ sender: Any) {
        if let hospitalName = hospitalTextField.text
        {
            if let errorMessage = invalidName(hospitalName)
            {
                nameErrorMSG.text = errorMessage
                nameErrorMSG.isHidden = false
                turnTextFieldTextfieldToRed(hospitalTextField)
            }
            else
            {
                nameErrorMSG.isHidden = true
                activeStyle(hospitalTextField)
            }
        }
        
        checkForValidForm()
    }
    
    @IBAction func phoneChanged(_ sender: Any) {
        if let phoneNumber = phoneTextField.text
        {
            if let errorMessage = invalidPhoneNumber(phoneNumber)
            {
                phoneErrorMSG.text = errorMessage
                phoneErrorMSG.isHidden = false
                turnTextFieldTextfieldToRed(phoneTextField)

            }
            else
            {
                phoneErrorMSG.isHidden = true
                activeStyle(phoneTextField)
            }
        }
        checkForValidForm()
    }
    
    
    
    // Validation
    func invalidName(_ value: String) -> String?
    {
        let set = CharacterSet(charactersIn: value)
        
        // Empty
        if value.count == 0
        {
            return "مطلوب"
        }
        
        // Not TEXT
        if CharacterSet.decimalDigits.isSuperset(of: set)
        {
            return "يجب ان يحتوي على احرف فقط"
        }
        
        // Invalid length
        if value.count < 2 || value.count > 30
        {
            return "الرجاء ادخال اسم صحيح"
        }
        return nil
    }
    
    func invalidPhoneNumber(_ value: String) -> String?
    {
        // Empty
        if value.count == 0
        {
            return "مطلوب"
        }
        
        let set = CharacterSet(charactersIn: value)
        if !CharacterSet.decimalDigits.isSuperset(of: set)
        {
            return "الرجاء ادخال رقم هاتف صحيح"
        }
        
        if value.count != 7
        {
            return "الرجاء ادخال رقم هاتف صحيح"
        }
        return nil
    }
    
    
    
    // Final Validation
    func checkForValidForm()
    {
        if nameErrorMSG.isHidden && phoneErrorMSG.isHidden
        {
            saveButton.isEnabled = true
        }
        else
        {
            saveButton.isEnabled = false
        }
    }
    
    
    
    
    
    
    
    
    
    @IBAction func Update(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            // User is signed in.

            let user = Auth.auth().currentUser
            let uid = user?.uid


            // get the Doc
            let docRef = database.collection("hospitalsInformation").document(uid!)
        
            // save data
            docRef.updateData(["name": hospitalTextField.text!,
                            "phone": phoneTextField.text!,
                           ]){ error in

                if error != nil {
                    print(error?.localizedDescription as Any)
                    // Show error message or pop up message
                    print ("error in saving the volunteer data")

                }
            }
        } else {
          // No user is signed in.
          print("No user")
        }
        // Show success message
        performSegue(withIdentifier: "hProfileUpdated", sender: self)
       
    }
}








// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


