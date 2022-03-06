//
//  bloodChartViewController.swift
//  Yumn
//
//  Created by Modhi Abdulaziz on 12/07/1443 AH.
//

import UIKit
import FirebaseFirestore
import Charts
//import NVActivityIndicatorView


class bloodChartViewController: UIViewController, ChartViewDelegate {
    
    let db = Firestore.firestore()
    var pieChart = PieChartView()
    
    @IBOutlet weak var viewPie: UIView!
    @IBOutlet weak var donateBloodLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart.delegate = self
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        guard let customFont = UIFont(name: "Tajawal-Bold", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        donateBloodLbl.font = UIFontMetrics.default.scaledFont(for: customFont)
        donateBloodLbl.adjustsFontForContentSizeCategory = true
        donateBloodLbl.font = donateBloodLbl.font.withSize(28)
        
       
        // for rounded top corners (view)
        if #available(iOS 11.0, *) {
                self.viewPie.clipsToBounds = true
            viewPie.layer.cornerRadius = 35
            viewPie.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else {
                // Fallback on earlier versions
            }
        
        
        //loadingIndicator(loadingTag: 1)
        
        setUpChart()
        
        getTotalBloodShortage(completion: { totalBloodDict in
            if let TBS = totalBloodDict {
                //use the return value
                self.populateChart(TBS: TBS)
             } else {
                 //handle nil response
                 print("couldn't build pie chart")
             }
               
            })
        
    }
    
    
    func getTotalBloodShortage( completion: @escaping ([String:Int]?)->())  {
       
        var totalBloodDict : [String : Int] = [
            "total_A_pos" : 0,
            "total_B_pos" : 0,
            "total_O_pos" : 0,
            "total_AB_pos" : 0,
            "total_A_neg" : 0,
            "total_B_neg" : 0,
            "total_O_neg" : 0,
            "total_AB_neg" : 0
        
        ]
        // this will be diff for organs, since in organs we want it from all the cities in SA, unlike the blood it's based on the city of the user

        // important
        // bring the current user city, make it voulnteer collection instead of users 
        /*
         let currentUserCity : String
         db.collection(const.FStore.usersCollection).document(currentUser.uid)
            .getDocument { (snapshot, error ) in

                 if let document = snapshot.data() {

         currentUserCity = document![const.FStore.cityField] as! String
                

                  } else {

                   print("current user document does not exist")

                 }
         }
         */
        
        
        let currentUserCity = "Riyadh" // will be changed to current user doc
        db.collection(const.FStore.hospitalCollection).whereField(const.FStore.cityField, isEqualTo: currentUserCity).addSnapshotListener { (QuerySnapshot, error) in
            if let e = error{
                print("there was an issue fetching hospitals with city = \(currentUserCity) from firestore. \(e)")
            }else {
                print("Number of documents: \(QuerySnapshot?.documents.count ?? -1)")
                if let snapshotDocuments=QuerySnapshot?.documents{
                    
                    print("Number of documents: \(QuerySnapshot?.documents.count ?? -1)")
                    
                    // iterate through documents to sum up the blood type values
                     snapshotDocuments.forEach({ (documentSnapshot) in
                      
                        let data = documentSnapshot.data()
                        
                        if let bloodShortageMapField = data[const.FStore.bShField] as? [String : Int]{
                       
                            totalBloodDict["total_A_pos"]! += (bloodShortageMapField[const.FStore.aPos]!)
                            totalBloodDict["total_B_pos"]! += (bloodShortageMapField[const.FStore.bPos]!)
                            totalBloodDict["total_O_pos"]! += (bloodShortageMapField[const.FStore.oPos]!)
                            totalBloodDict["total_AB_pos"]! += (bloodShortageMapField[const.FStore.abPos]!)
                            
                            totalBloodDict["total_A_neg"]! += (bloodShortageMapField[const.FStore.aNeg]!)
                            totalBloodDict["total_B_neg"]! += (bloodShortageMapField[const.FStore.bNeg]!)
                            totalBloodDict["total_O_neg"]! += (bloodShortageMapField[const.FStore.oNeg]!)
                            totalBloodDict["total_AB_neg"]! += (bloodShortageMapField[const.FStore.abNeg]!)
                            

                        } // end of if map
                    }) // end forEach
                        
                      
                    
                    }
                }
            completion(totalBloodDict)
            }
          
    }
    
  /*
    fileprivate func loadingIndicator(loadingTag:Int){
        
        /*
        pieChart.noDataText = "Loading"
        pieChart.noDataTextColor = .blue
        pieChart.noDataFont = UIFont(name: "Helvetica", size: 10.0)!
        */
        
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballClipRotateMultiple, color: const.Colors.yellow, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 40),
            loading.heightAnchor.constraint(equalToConstant: 40),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        // 1 to start animation of loading indicator
        if loadingTag == 1 {
            loading.startAnimating()
        }
        
        else {
            loading.stopAnimating()
        }
        
    }
    */
    
    func setUpChart(){
        
        pieChart.frame = CGRect(x: 0, y: 0,
                                width: self.view.frame.size.width,
                                height: self.view.frame.size.width)
        pieChart.center = view.center
        view.addSubview(pieChart)
        
    }
    
    
    func populateChart(TBS : [String:Int]){
        
        let totalBSh : Int = TBS["total_A_pos"]! + TBS["total_A_neg"]! +
                            TBS["total_B_pos"]! + TBS["total_B_neg"]! +
                            TBS["total_O_pos"]! + TBS["total_O_neg"]! +
                            TBS["total_AB_pos"]! + TBS["total_AB_neg"]!
        
        
        
                             
        let aPosPercentage : Int = TBS["total_A_pos"]!
        let bPosPercentage : Int = TBS["total_B_pos"]!
        let oPosPercentage : Int = TBS["total_O_pos"]!
        let abPosPercentage : Int = TBS["total_AB_pos"]!
        
        let aNegPercentage : Int = TBS["total_A_neg"]!
        let bNegPercentage : Int = TBS["total_B_neg"]!
        let oNegPercentage : Int = TBS["total_O_neg"]!
        let abNegPercentage : Int = TBS["total_AB_neg"]!
        
      
         let pieChartEntry: [PieChartDataEntry] = [
             
         
             PieChartDataEntry(value: Double((Double(aPosPercentage)/Double(totalBSh))*100), label: "A+"),
             PieChartDataEntry(value: Double((Double(bPosPercentage)/Double(totalBSh))*100), label: "B+"),
             PieChartDataEntry(value: Double((Double(oPosPercentage)/Double(totalBSh))*100), label: "O+"),
             PieChartDataEntry(value: Double((Double(abPosPercentage)/Double(totalBSh))*100), label: "AB+"),
             
             
             PieChartDataEntry(value: Double((Double(aNegPercentage)/Double(totalBSh))*100), label: "A-"),
             PieChartDataEntry(value: Double((Double(bNegPercentage)/Double(totalBSh))*100), label: "B-"),
             PieChartDataEntry(value: Double((Double(oNegPercentage)/Double(totalBSh))*100), label: "O-"),
             PieChartDataEntry(value: Double((Double(abNegPercentage)/Double(totalBSh))*100), label: "AB-")
         ]
         let set = PieChartDataSet(entries: pieChartEntry)
         //set.colors = ChartColorTemplates.colorful() //colorful()
         set.colors = [const.Colors.green, const.Colors.yellow, const.Colors.orange, const.Colors.pink, const.Colors.green, const.Colors.yellow, const.Colors.orange, const.Colors.pink
        ]
         let data = PieChartData(dataSet: set)
       //  self.pieChart.drawHoleEnabled = false
         
         let pFormater = NumberFormatter()
         pFormater.numberStyle = .percent
         pFormater.maximumFractionDigits = 1
         pFormater.multiplier = 1
         pFormater.percentSymbol = "%"
         
         data.setValueFormatter(DefaultValueFormatter(formatter: pFormater))
         self.pieChart.data = data
         //self.pieChart.usePercentValueEnabled = true
        
        self.pieChart.legend.enabled = false
        /* let legend = self.pieChart.legend
         legend.horizontalAlignment = .center
         legend.verticalAlignment = .bottom
         legend.orientation = .horizontal*/
       //  self.pieChart.data=data
    }
}// end of class
