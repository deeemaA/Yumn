//
//  PopupAddForm.swift
//  Yumn
//
//  Created by Rawan Mohammed on 19/03/2022.
//

import SwiftUI
import UIKit
import Combine

struct PopupAddForm: View {
    var controller: ManageAppointmentsViewController = ManageAppointmentsViewController()
    
    @State var date: Date? = Date()
    
    // colors
    
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let lightGray = Color(UIColor.lightGray)
    let redC = Color(UIColor.red)
    let newWhite: Color = Color(red: 250 / 255, green: 250 / 255, blue: 250 / 255)
    
    // dropdown variables
    
    @State var durationPerAText = ""
    @State var durationPerA: Double = 0
    var placeholder = "اختر مدة الموعد"
    var dropDownList = ["15 دقيقة", "30 دقيقة", "1 ساعة"]
    
    
    @State var selectedDate: Date = Date()
    
    @State var durationText = ""
    
    @State var duration: Int = 0
    
    @State var endDateTxt = ""
    
    @State var endDate: Date = Date()
    
    @State var peoplePerAText = ""
    @State var peoplePerA: Int = 0
    
    @State var durationValue: Double = 0
    
    
    @ObservedObject var aptVM = AppointmentVM()
    
    
    init(controller: ManageAppointmentsViewController, date: Date){
        self.date = date
        self.controller = controller
    }
    
    var body: some View {
        
        VStack(spacing: 0){
            
            ZStack(alignment: .topLeading){
                
                VStack(alignment: .leading){
                    Button(action: {
                        controller.hideOverlay()
                    }) {
                        Text("x").font(Font.custom("Tajawal", size: 30))
                            .foregroundColor(lightGray)
                    }
                    
                    
                }.padding(.leading, 20)
                
                Text("إضافة موعد").font(Font.custom("Tajawal", size: 20))
                    .foregroundColor(mainDark)
                    .frame(maxWidth: .infinity)
                //                    .padding(.leading, -25)
                
                
            }.frame(maxWidth: .infinity)
            
            
            Form(){
                
                
                
                if #available(iOS 15.0, *) {
                    
                    VStack(alignment: .trailing, spacing: 20){
                        createLabel(label: "وقت بداية فترة المواعيد")
                        //                    DatePickerInputView(date: $date ,placeholder: "here")
                        
                        DatePicker("",
                                   selection: $selectedDate, displayedComponents: [.hourAndMinute])
                        //                        .datePickerStyle(CompactDatePickerStyle())
                            .accentColor(.white)
                            .background(mainDark.colorInvert())
                            .cornerRadius(15)
                            .foregroundColor(.white)
                            .preferredColorScheme(.light)
                            .colorInvert()
                            .labelsHidden()
                            .buttonStyle(BorderlessButtonStyle())
                            .frame(maxWidth: .infinity)
                        
                        
                    }.listRowSeparator(.hidden)
                    
                    
                    
                    //                    VStack(alignment: .trailing){
                    //                        createLabel(label: "وقت انتهاء الموعد")
                    //                        //                    DatePickerInputView(date: $date ,placeholder: "here")
                    //
                    //                        var endTimepicker = DatePicker("",
                    //                                                       selection: $selectedDate, displayedComponents: [.hourAndMinute])
                    //                        //                        .datePickerStyle(CompactDatePickerStyle())
                    //                            .accentColor(.white)
                    //                            .background(mainDark.colorInvert())
                    //                            .cornerRadius(15)
                    //                            .foregroundColor(.white)
                    //                            .preferredColorScheme(.light)
                    //                            .colorInvert()
                    //                            .labelsHidden()
                    //                            .buttonStyle(BorderlessButtonStyle())
                    //                            .frame(maxWidth: .infinity)
                    //
                    //                        endTimepicker
                    //
                    //
                    //                    }.listRowSeparator(.hidden)
                    //                        .padding(.top)
                    
                    
                    VStack(alignment: .trailing, spacing: 5){
                        
                        createLabel(label: "مدة فترة المواعيد")
                        
                        HStack(){
                            Spacer()
                            ZStack(){
                                //                        Spacer()
                                
                                //                            createLabel(label: "دقيقة")
                                HStack(){
                                    Text("ساعة").font(Font.custom("Tajawal", size: 17)).foregroundColor(mainDark).multilineTextAlignment(.leading)
                                    Spacer()
                                    //                            .frame(maxWidth: .infinity)
                                    
                                }
                                
                                
                                TextField("", text: $durationText)
                                    .placeholder(when: durationText.isEmpty){
                                        Text("المدة").font(Font.custom("Tajawal", size: 15)).foregroundColor(lightGray)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.trailing)
                                    .underlineTextField()
                                    .keyboardType(.numberPad)
                                //                                    .onReceive( Just( durationText ), perform: {
                                //                                            let newValue = self.contentType.filterCharacters( oldValue: $0 )
                                //                                            if newValue != self.durationText {
                                //                                                self.durationText = newValue
                                //                                            }
                                //                                        })
                                    .onChange(of: durationText){newValue in
                                        if(!newValue.isEmpty){
                                            duration = Int(newValue)!
                                        }
                                    }
                                
                            }
                            //                            .padding(.leading, UIScreen.screenWidth / 2.5 )
                            
                            
                        }
                        
                        
                        
                    }.listRowSeparator(.hidden)
                        .padding(.top, 20)
                    
                    
                    
                    HStack(alignment: .center){
                        TextField("", text: $endDateTxt)
                            .disabled(true)
                            .font(Font.custom("Tajawal", size: 17))
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.trailing)
                        //                        .underlineTextField()
                            .onChange(of: durationText){newValue in
                                if(!newValue.isEmpty){
                                    self.durationValue = Double(newValue)!
                                    endDate = selectedDate.addingTimeInterval(durationValue * 60 * 60)
                                    endDateTxt = endDate.getFormattedDate(format: "HH:mm")
                                } else {
                                    endDateTxt = ""
                                }
                            }
                            .onChange(of: selectedDate){newValue in
                                //                                    let value = Double(newValue)!
                                endDate = newValue.addingTimeInterval(durationValue * 60 * 60)
                                endDateTxt = endDate.getFormattedDate(format: "HH:mm")
                            }
                        
                        createLabel(label: "تنتهي الفترة:")
                        
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .listRowSeparator(.hidden)
                    
                    VStack(alignment: .trailing, spacing: 20){
                        createLabel(label: "مدة الموعد")
                        
                        Menu {
                            ForEach(dropDownList, id: \.self){ client in
                                Button(client) {
                                    self.durationPerAText = client
                                }.multilineTextAlignment(.trailing)
                            }.onChange(of: durationPerAText){newValue in
                                if(!newValue.isEmpty){
                                    switch newValue{
                                    case dropDownList[0]:
                                        self.durationPerA = 15
                                        break
                                    case dropDownList[1]:
                                        self.durationPerA = 30
                                        break
                                    case dropDownList[2]:
                                        self.durationPerA = 60
                                        break
                                    default:
                                        self.durationPerA = 0
                                    }
                                }
                            }
                            
                        } label: {
                            VStack(spacing: 5){
                                HStack{
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(mainDark)
                                        .font(Font.system(size: 20, weight: .bold))
                                    Spacer()
                                    Text(durationPerAText.isEmpty ? placeholder : durationPerAText)
                                        .foregroundColor(durationText.isEmpty ? .gray : .black).font(Font.custom("Tajawal", size: 15))
                                }
                                .padding(.horizontal)
                                Rectangle()
                                    .fill(mainDark)
                                    .frame(height: 1)
                                    .padding(.top, 8)
                                    .padding(.horizontal , 10)
                            }
                        }
                        
                        
                    }.frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
                    //                        .padding(.top, 10)
                    
                    VStack(alignment: .trailing, spacing: 5){
                        
                        createLabel(label: "عدد الأشخاص لكل موعد")
                        
                        TextField("", text: $peoplePerAText)
                            .placeholder(when: peoplePerAText.isEmpty){
                                Text("عدد الأشخاص").font(Font.custom("Tajawal", size: 15)).foregroundColor(lightGray)
                            }
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.trailing)
                            .underlineTextField()
                            .keyboardType(.numberPad)
                            .onChange(of: peoplePerAText){newValue in
                                if(!newValue.isEmpty){
                                    self.peoplePerA = Int(newValue)!
                                }
                            }
                        
                        
                    }
                    .listRowSeparator(.hidden)
                    .padding(.top, 20)
                    
                    HStack(){
                        Button(action: {
                            saveData()
                        }) {
                            Text("إضافة").font(Font.custom("Tajawal", size: 20))
                                .foregroundColor(.white)
                                .padding(.horizontal, 75)
                                .padding(.vertical, 10)
                            
                        }
                        .background(
                            RoundedRectangle(
                                cornerRadius: 20,
                                style: .continuous
                            )
                                .fill(mainDark)
                        )
                    }.padding(.top, 20)
                        .frame(maxWidth: .infinity)
                    
                    
                } else {
                    // Fallback on earlier versions
                }
                
            }.padding(0)
                .background(Color.white)
            
        }.onAppear(){
            
            UIDatePicker.appearance().backgroundColor = .clear
            UITableView.appearance().backgroundColor = .white
            
        }.onDisappear(){
            UIDatePicker.appearance().backgroundColor = .systemGroupedBackground
            UITableView.appearance().backgroundColor = .systemGroupedBackground
        }
        
        
    }
    
    
    func createLabel(label: String)-> Text {
        return Text(label).font(Font.custom("Tajawal", size: 17)).foregroundColor(mainDark)
    }
    
    
    func saveData() {
        print("hereeeee1111")
        var apt = Appointment(type: "blood", startTime: selectedDate, endTime: endDate, aptDate: date!, hospital: "mamlakah", donors: 5)
        apt.aptDuration = durationPerA
        apt.appointments = createAppointmentList()
        
        aptVM.addData(apt: apt)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 , execute: {
            if(aptVM.added){
                self.controller.showSuccessPopUp()
            }
            else {
                self.controller.showFailPopUp()
            }
        })
    }
    
    func createAppointmentList() -> [DAppointment] {
        
        print("hereeeee222222")
        var list = [DAppointment]()
        
        var currentDate = selectedDate
        var num = 0
        
        while(currentDate != endDate){
            num += 1
            let currentEnd = currentDate.addingTimeInterval(durationPerA * 60)
            
            list.append(DAppointment(type: "blood", startTime: currentDate, endTime: currentEnd, donor: "", hName: "mamlakah", confirmed: false, booked: false))
            
            currentDate = currentDate.addingTimeInterval(durationPerA * 60)
        }
        
        print("\(list.count)")
        return list
        
    }
    
}

struct PopupAddForm_Previews: PreviewProvider {
    static var previews: some View {
        PopupAddForm(controller: ManageAppointmentsViewController(), date: Date())
    }
}


extension View {
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .trailing,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func underlineTextField() -> some View {
        self
        //            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 1).padding(.top, 35))
            .foregroundColor(Color(UIColor.init(named: "mainDark")!))
            .padding(10)
    }
    
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
