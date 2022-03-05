//
//  ViewController.swift
//  Yumn
//
//  Created by Deema Almutairi on 24/01/2022.
//

import UIKit
import SwiftUI
import CoreLocation
import FirebaseAuth
import Firebase

class VHomeViewController: UIViewController {
    
    @IBOutlet weak var logOutBtn: UIBarButtonItem!
    
    @IBOutlet weak var topNavBar: UINavigationItem!
    
    @ObservedObject var lm = LocationManager()

    override func viewDidLoad() {
 
        
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("volunteer").document(Auth.auth().currentUser!.uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let seconds = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    
                    // Put your code which should be executed with a delay here
                    
                    
                let name = document.get("firstName") as! String
                    let mssg = "حياك الله " + name  + "، تو ما نور يُمْن"
                    

                    self.showToast(message: mssg, font: .systemFont(ofSize: 20), image: (UIImage(named: "yumn-1") ?? UIImage(named: "")! ))}

                
                print (Constants.Globals.firstNameFromdb)
            } else {
                print("Document does not exist")
            }
        }
        
        
        super.viewDidLoad()
        print("\(String(describing: lm.location))")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToBloodDonation" {
            let destinationVC = segue.destination as! BloodDonationViewController
            destinationVC.userLocation = lm.getUserLocation()
            destinationVC.location = lm.location
//            destinationVC.advice = calculatorBrain.getAdvice()
//            destinationVC.color = calculatorBrain.getColor()
        }
    }
    

    
}

extension UIViewController {

    func showToast(message : String, font: UIFont, image: UIImage){

    let toastLabel = UILabel(frame: CGRect(x: 5, y: 45, width: self.view.frame.size.width-10, height: 70))
        

        toastLabel.backgroundColor = UIColor.gray.withAlphaComponent(1)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
   

        
    let imageView = UIImageView(frame: CGRect(x: self.view.frame.size.width-70, y: 10, width: 45, height: 45))
        imageView.layer.masksToBounds = true

    imageView.image = image
        imageView.layer.cornerRadius = 10
        
 

        toastLabel.addSubview(imageView)
        
        self.navigationController?.view.addSubview(toastLabel)

    UIView.animate(withDuration: 10, delay: 5, options:
                    
                    
                    .transitionFlipFromTop, animations: {

                        
         toastLabel.alpha = 0.0

    }, completion: {(isCompleted) in
        
        

        toastLabel.removeFromSuperview()



    })
}
    
}