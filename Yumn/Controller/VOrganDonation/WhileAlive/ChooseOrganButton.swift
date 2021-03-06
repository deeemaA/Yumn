//
//  ChooseOrganButton.swift
//  Yumn
//
//  Created by Rawan Mohammed on 21/04/2022.
//

import SwiftUI
import Firebase
import FirebaseAuth
import Combine

struct ChooseOrganButton: View {
    
    var config: Configuration?
    
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let lightGray = Color(UIColor.lightGray)
    let whiteBg = Color(UIColor.white)
    let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))
    @State var listener: ListenerRegistration?
    @State var cancellable : AnyCancellable?
    
    let userID = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    @State var kidney = false
    @State var liver = false
    
    @State var kidneyApp = true
    @State var LiverApp = true
    
    init(config: Configuration) {
        self.config = config
    }
    
    var body: some View {
        HStack(spacing: 0){
            VStack(){
                if(!liver){
                    Image("liver")
                        .resizable()
                        .scaledToFit()
                        .padding(.leading)
                        .padding(.trailing)
                    Text("التبرع بجزء من الكبد").font(Font.custom("Tajawal", size: 18))
                        .foregroundColor(mainLight)
                } else {
                    Image("whiteLiver")
                        .resizable()
                        .scaledToFit()
                        .padding(.leading)
                        .padding(.trailing)
                    Text("التبرع بجزء من الكبد").font(Font.custom("Tajawal", size: 18))
                        .foregroundColor(.white)
                }
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background((liver) ? mainLight : whiteBg)
                .cornerRadius(20, corners: [.bottomLeft, .topLeft])
                .shadow(color: shadowColor,
                        radius: 6, x: 0
                        , y: 6)
                .onTapGesture {
                    cancellable = checkAppointments(type: "liver").receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            print("finished")
                        case .failure(let error):
                            print(error)
                        }
                    }, receiveValue: { success in
                        print(success)
                        if(success){
                            liver.toggle()
                            Constants.selected.selectedOrgan.organ = "liver"
                            if(liver){
                                if(LiverApp){
                                    let x =
                                    config!.hostingController?.parent as! AliveFirstVC
                                    x.showPopup()
                                } else {
                                    kidney = false
                                    let x =
                                    config!.hostingController?.parent as! AliveFirstVC
                                    x.moveToKindneySection()
                                }
                            }
                        } else {
                            let x =
                            config!.hostingController?.parent as! AliveFirstVC
                            x.showPopup()
                        }
                    })
                }
            
            VStack(){
                
                if(!kidney){
                    Image("alive_organ_donation")
                        .resizable()
                        .scaledToFit()
                        .padding(.leading)
                        .padding(.trailing)
                    Text("التبرع بكلية").font(Font.custom("Tajawal", size: 18))
                        .foregroundColor(mainLight)
                } else {
                    Image("whiteKidney")
                        .resizable()
                        .scaledToFit()
                        .padding(.leading)
                        .padding(.trailing)
                    Text("التبرع بكلية").font(Font.custom("Tajawal", size: 18))
                        .foregroundColor(.white)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background((kidney) ? mainLight : whiteBg)
                .cornerRadius(20, corners: [.bottomRight, .topRight])
                .shadow(color: shadowColor,
                        radius: 6, x: 3
                        , y: 6)
                .onTapGesture {
                    cancellable = checkAppointments(type: "kidney").receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            print("finished")
                        case .failure(let error):
                            print(error)
                        }
                    }, receiveValue: { success in
                        print(success)
                        if(success){
                            kidney.toggle()
                            Constants.selected.selectedOrgan.organ = "kidney"
                            if(kidney){
                                if(kidneyApp){
                                    let x =
                                    config!.hostingController?.parent as! AliveFirstVC
                                    x.showPopup()
                                } else {
                                    liver = false
                                    let x =
                                    config!.hostingController?.parent as! AliveFirstVC
                                    x.moveToKindneySection()
                                }
                            }
                        } else {
                            let x =
                            config!.hostingController?.parent as! AliveFirstVC
                            x.showPopup()
                        }
                    })
                }
            
        }
        .frame(width: UIScreen.screenWidth - 80, height: UIScreen.screenHeight - 600, alignment: .center).background(
            RoundedRectangle(
                cornerRadius: 40,
                style: .continuous
            )
                .fill(.white)
        ).onAppear {
            //            DispatchQueue.main.async {
            //                self.checkAppointments(type: <#T##String#>)
            //            }
        }.onDisappear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                listener?.remove()
            }
        }
        //            .shadow(color: shadowColor,
        //                    radius: 6, x: 0
        //                    , y: 6)
    }
    
    func checkAppointments(type: String) -> Future<Bool, Error>{
        return Future<Bool, Error> { promise in
            
            DispatchQueue.main.async {
                
                listener =  db.collection("volunteer").document(userID).collection("organAppointments").whereField("organ", in: [type]).addSnapshotListener({ documentSnapshot, error in
                    
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    
                    if(error == nil){
                        if(document.count == 0){
                            if(type == "kidney"){
                                kidneyApp = false
                            }
                            if(type == "liver"){
                                LiverApp = false
                            }
                            print(document.count)
                            promise(.success(true))
                            print("there are none")
                        } else {
                            if(type == "kidney"){
                                kidneyApp = false
                            }
                            if(type == "liver"){
                                LiverApp = false
                            }
                            promise(.success(false))
                        }
                        
                    }
                    else {
                        promise(.failure(error as! Error))
                    }
                    
                })
            }
        }
    }
}

struct ChooseOrganButton_Previews: PreviewProvider {
    static var previews: some View {
        ChooseOrganButton(config: Configuration())
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct SelectedOrgan {
    var organ: String
    var hospital: String
    var appointment: String
    var organHospitals: [String]
}

