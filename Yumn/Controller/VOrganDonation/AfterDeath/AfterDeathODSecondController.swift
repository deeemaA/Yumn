//
//  AfterDeathODFirstController.swift
//  Yumn
//
//  Created by Rawan Mohammed on 17/04/2022.
//

import Foundation
import UIKit
import SwiftUI

class AfterDeathODSecondController: UIViewController {
    
    @IBOutlet weak var roundedView: RoundedView!
    
    @IBOutlet weak var blackBlurredView: UIView!

    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var popupTitle: UILabel!
    
    @IBOutlet weak var popupMsg: UILabel!
    
    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var selectionHolder: UIView!

    
    var questions = [false, false,false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewWillAppear(true)
        
        popupView.superview?.bringSubviewToFront(popupView)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
//        contBtn.layer.cornerRadius = 25
        okBtn.layer.cornerRadius = 15
        popupView.layer.cornerRadius = 30
        
        
        let childView = UIHostingController(rootView: AfterDeathOrganSelection(controller: self))
        addChild(childView)
        childView.view.frame = selectionHolder.bounds
        selectionHolder.addSubview(childView.view)
        
        
//        q1Btn.contentHorizontalAlignment = .right
//        q2Btn.contentHorizontalAlignment = .right
//        q3btn.contentHorizontalAlignment = .right
//        q4Btn.contentHorizontalAlignment = .right
//        q5Btn.contentHorizontalAlignment = .right
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.navigationController?.navigationBar.tintColor = UIColor.white
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
        nav?.barTintColor = UIColor.init(named: "mainLight")
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
        nav?.tintColor = UIColor.init(named: "mainLight")
        nav?.barTintColor = UIColor.init(named: "mainLight")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "mainLight")!, NSAttributedString.Key.font: customFont]
    }
    
    
    func onPressedCont(valid: Bool) {
        
        if (!valid){
            
            popupTitle.text = "مقدرين حبك للمساعدة"
//            popupMsg.text = """
//للأسف، أنت غير مؤهل للتبرع
//            بالأعضاء بعد الوفاة
//"""
            popupView.isHidden = false
            blackBlurredView.isHidden = false
        }
        
        else{
            
            performSegue(withIdentifier: "goToOrganSelection", sender: nil)
            
            //Go to next page
        }
    }
    
}