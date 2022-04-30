import SwiftUI
import Firebase
import FirebaseAuth

struct VAppointmentsView: View {
    
    var config = Configuration()
    
    @StateObject var odVM = ODAppointmentVM()
    
    @ObservedObject var aptVM = VAppointments()
    
    
    @State var selectedDate: Date = Date()
    @State var checkedIndex: Int = -1
    @State var showError = false
    
    @Namespace var animation
    
    @State var activate = false
    
    let dateFormatter = DateFormatter()
    
    let shadowColor = Color(#colorLiteral(red: 0.8653315902, green: 0.8654771447, blue: 0.8653123975, alpha: 1))
    let mainDark = Color(UIColor.init(named: "mainDark")!)
    let mainLight = Color(UIColor.init(named: "mainLight")!)
    let lightGray = Color(UIColor.lightGray)
    let bgWhite = Color(UIColor.white)
    let grey = Color(UIColor.gray)
    
    var thereIS = chechingAppointments()
    
    var calender = Calendar.current
    
    init(config: Configuration){
        self.config = config
        aptVM.currentDay = Date()
        activate = true
    }
    
    //        var appointments: [Appointment] =
    //        [
    //            OrganAppointment(appointments:
    //                                [DAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), donor: "", hName: Constants.selected.selectedOrgan.hospital, confirmed: false, booked: false)]
    //                             , type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(60 * 60), aptDate: getSampleDate(offset: 1), hospital: Constants.selected.selectedOrgan.hospital, aptDuration: 60, organ: Constants.selected.selectedOrgan.organ),
    //            OrganAppointment(appointments:
    //                                [DAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), donor: "", hName: Constants.selected.selectedOrgan.hospital, confirmed: false, booked: false)]
    //                             , type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(60 * 60), aptDate: getSampleDate(offset: 0), hospital: Constants.selected.selectedOrgan.hospital, aptDuration: 60, organ: Constants.selected.selectedOrgan.organ),
    //            OrganAppointment(appointments:
    //                                [DAppointment(type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(30 * 60), donor: "", hName: Constants.selected.selectedOrgan.hospital, confirmed: false, booked: false)]
    //                             , type: "organ", startTime: Date(), endTime: Date().addingTimeInterval(60 * 60), aptDate: getSampleDate(offset: -2), hospital: Constants.selected.selectedOrgan.hospital, aptDuration: 60, organ: Constants.selected.selectedOrgan.organ),
    //        ]
    
    var weekdaysAR: [String:String] =
    [
        "Sun": "الأحد",
        "Mon": "الأثنين",
        "Tue": "الثلاثاء",
        "Wed": "الاربعاء",
        "Thu":"الخميس",
        "Fri":"الجمعة",
        "Sat":"السبت"
    ]
    
    var arOrgan: [String?:String] =
    [
        "kidney":"كلية",
        "liver":"جزء من الكبد",
    ]
    
    var body: some View {
        if #available(iOS 15.0, *){
            
            
            // MARK: current week view
            
            VStack(spacing: 15){
                
                Section{
                    
                    // MARK: current week view
                    ScrollView(.horizontal, showsIndicators: false){
                        ScrollViewReader { value in
                            HStack(spacing: 20){
                                
                                
                                VStack(spacing: 5){
                                    Text("مواعيد").font(Font.custom("Tajawal", size: 13))
                                        .foregroundColor( .white).fontWeight(.semibold)
                                    
                                    Text("سابقة").font(Font.custom("Tajawal", size: 13))
                                        .foregroundColor( .white).fontWeight(.semibold)
                                    
                                }
                                .frame(width: 90, height: 90)
                                .background(
                                    // MARK: Mathed gemotry
                                    RoundedRectangle(
                                        cornerRadius: 10,
                                        style: .continuous
                                    ).fill(mainDark)
                                    //                                            .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                    
                                )
                                .onTapGesture {
                                    var x =
                                    config.hostingController?.parent as! VViewAppointmentsVC
                                    x.moveToOldApts()
                                }
                                
                                
                                
                                
                                // MARK: Display dates
                                ForEach(0..<odVM.currentWeek.count, id: \.self){ day in
                                    VStack(spacing: 5){
                                        Text(odVM.extractDate(date: odVM.currentWeek[day], format: "dd")).font(Font.custom("Tajawal", size: 25))
                                            .foregroundColor(odVM.isToday(date: odVM.currentWeek[day]) ? .white : mainDark).fontWeight(.semibold)
                                        
                                        // MARK: Returns days
                                        Text(weekdaysAR[odVM.extractDate(date: odVM.currentWeek[day], format: "EEE")]!).font(Font.custom("Tajawal", size: 14))
                                            .foregroundColor(odVM.isToday(date: odVM.currentWeek[day]) ? .white : mainDark)
                                        //                                            .foregroundColor(self.organsVM.selected[organ]! ? .white : mainDark)
                                        
                                        // MARK: circle under
                                        ZStack{
                                            Circle().fill(appointmentsOnDate(date: odVM.currentWeek[day]) ? mainDark : .white)
                                                .frame(width: 8, height: 8)
                                                .opacity(appointmentsOnDate(date: odVM.currentWeek[day]) ? 1 : 0)
                                            
                                            if(calender.isDate( odVM.currentWeek[day], inSameDayAs: selectedDate)){
                                                Circle().fill(.white)
                                                    .frame(width: 8, height: 8)
                                                    .opacity(appointmentsOnDate(date: odVM.currentWeek[day]) ? 1 : 0)
                                            }
                                            
                                        }
                                        
                                    }.id(day)
                                    //                                        .foregroundStyle(odVM.isToday(date: odVM.currentWeek[day]) ? .primary : .tertiary)
                                        .frame(width: 90, height: 90)
                                        .background(
                                            ZStack{
                                                // MARK: Mathed gemotry
                                                if(odVM.isToday(date: odVM.currentWeek[day])){
                                                    RoundedRectangle(
                                                        cornerRadius: 10,
                                                        style: .continuous
                                                    ).fill(mainDark)
                                                        .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                                } else {
                                                    RoundedRectangle(
                                                        cornerRadius: 10,
                                                        style: .continuous
                                                    ).fill(bgWhite)
                                                }
                                                //                                                    .fill(self.organsVM.selected[organ]! ? mainDark : .white)
                                            }
                                        )
                                        .shadow(color: shadowColor,
                                                radius:  odVM.isToday(date: odVM.currentWeek[day]) ? 0 : 3, x: 0
                                                , y:  odVM.isToday(date: odVM.currentWeek[day]) ? 0 : 6)
                                        .onTapGesture {
                                            // updating current date
                                            selectedDate = odVM.currentWeek[day]
                                            withAnimation {
                                                odVM.currentDay = odVM.currentWeek[day]
                                            }
                                        }.onChange(of: selectedDate) { newValue in
                                            aptVM.currentDay = newValue
                                            aptVM.filteringAppointments()
                                        }
                                }
                                
                                VStack(spacing: 5){
                                    Text("مواعيد").font(Font.custom("Tajawal", size: 13))
                                        .foregroundColor( .white).fontWeight(.semibold)
                                    
                                    Text("قادمة").font(Font.custom("Tajawal", size: 13))
                                        .foregroundColor( .white).fontWeight(.semibold)
                                    
                                }
                                .frame(width: 90, height: 90)
                                .background(
                                    // MARK: Mathed gemotry
                                    RoundedRectangle(
                                        cornerRadius: 10,
                                        style: .continuous
                                    ).fill(mainDark)
                                )
                                .onTapGesture {
                                    let x =
                                    config.hostingController?.parent as! VViewAppointmentsVC
                                    x.moveToFutureApts()
                                }
                                
                            }.onAppear(){ // <== Here
                                DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                                    value.scrollTo(6)
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                    dateFormatter.locale = Locale(identifier:"en_US_POSIX")
                                    aptVM.filteringAppointments()
                                })
                            }.onChange(of: activate) { newValue in
                                DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                                    value.scrollTo(6)
                                })
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                            
                            //                        .environment(\.layoutDirection, .rightToLeft)
                        }
                    }
                    
                    ScrollView(.vertical,  showsIndicators: false){
                        AppointmentsView()
                    }
                    
                    Spacer()
                    
                } header: {
                    HeaderView()
                    
                    
                }
                
            }
            .onAppear(){
                activate = true
                odVM.fetchCurrentWeek(weeks: 3)
            }.environment(\.layoutDirection, .rightToLeft)
            //
            
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 10){
            VStack(){
                Text(convertToArabic(date: Date())).font(Font.custom("Tajawal", size: 14))
                    .foregroundColor(.gray)
                
                Text("اليوم").font(Font.custom("Tajawal", size: 20))
                    .foregroundColor(lightGray).padding(.top, 7)
                
            }.hLeading()
        }.padding()
            .background(bgWhite)
    }
    
    
    // MARK: Appointments View
    func AppointmentsView() -> some View {
        
        LazyVStack(spacing: 18){
            if let apts = aptVM.filteredAppointments {
                
                if apts.isEmpty {
                    Text("لا توجد مواعيد").font(Font.custom("Tajawal", size: 16))
                        .foregroundColor(lightGray).padding(.top, 100).multilineTextAlignment(.center)
                    
                } else {
                    ForEach(0..<apts.count, id: \.self){ index in
                        AppoitmentCard(apt: apts[index], index: index)
                    }
                }
                
            } else {
                //MARK: Progress view
                ProgressView()
                    .offset(y: 100).foregroundColor(mainDark)
            }
        }.frame(maxHeight: .infinity)
            .padding(.top, 10)
        
    }
    
    //    @available(iOS 15.0, *)
    @ViewBuilder
    func AppoitmentCard(apt: retrievedAppointment, index: Int) -> some View {
        
        HStack(){
            
            let today = dateFormatter.string(from: Date())
            let aptDate = dateFormatter.string(from: apt.date!)
            Spacer()
            
            VStack(alignment: .leading, spacing: 5){
                let title = "موعد فحص مبدئي للتبرع بـ "
                let place = "في "
                
                HStack(){
                    Text(title + self.arOrgan[apt.organ]!).font(Font.custom("Tajawal", size: 17))
                        .foregroundColor(mainDark).padding(.bottom, 10).padding(.top, 10)
                    
                    Spacer()
                    if(today < aptDate){
                        let colorInvert = Color(UIColor.init(named: "mainDark")!.inverted)
                        VStack(){
                            Image(systemName: "x.circle.fill").foregroundColor(colorInvert).colorInvert()
                                .scaledToFit().font(.system(size: 17).bold())
                                .onTapGesture {
                                    let x =
                                    config.hostingController?.parent as! VViewAppointmentsVC
                                    x.cancel(apt: apt)
                                }
                            
                        }.padding(.top, 0).padding(.bottom, 0)
                        
                    }
                    if(today >= aptDate){
                        let colorInvert = Color(UIColor.gray.inverted)
                        VStack(){
                            Image(systemName: "x.circle.fill").foregroundColor(colorInvert).colorInvert()
                                .scaledToFit().font(.system(size: 17).bold())
                        }.padding(.top, 0).padding(.bottom, 0)
                        
                    }
                }
                Text(place + apt.hName!).font(Font.custom("Tajawal", size: 14)).foregroundColor(mainDark)
                
                HStack(){
                    
                    VStack(){
                        Image("location").resizable()
                            .scaledToFit()
                    }.padding(.top, 10).padding(.bottom, 10)
                    Text(apt.hospitalLocation!).font(Font.custom("Tajawal", size: 12)).foregroundColor(mainDark)
                        .padding(.trailing, 10).padding(.top, 4).padding(.leading, -5)
                    
                    
                    VStack(){
                        Image("time").resizable()
                            .scaledToFit()
                    }.padding(.top, 14).padding(.bottom, 14)
                    
                    Text("\(apt.startTime!.getFormattedDate(format: "HH:mm")) - \(apt.endTime!.getFormattedDate(format: "HH:mm"))").font(Font.custom("Tajawal", size: 12))
                        .foregroundColor(mainDark).padding(.top, 7)
                    
                    Spacer()
                    
                    self.editButton(isFuture: (today < aptDate))
                    
                    
                } .padding(.bottom, 5)
                
                
                
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 110)
                .padding(10)
            
        }
        .background(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
                .fill(.white)
        )
        .frame(height: 110, alignment: .center)
        .frame(maxWidth: .infinity)
        .shadow(color: shadowColor,
                radius: 6, x: 0
                , y: 6)
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        
    }
    
    @ViewBuilder
    func editButton(isFuture: Bool) -> some View {
        if(isFuture){
            Button(action: {
                let x =
                config.hostingController?.parent as! VViewAppointmentsVC
            }
            ) {
                Text("تعديل").font(Font.custom("Tajawal", size: 16))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(
                    cornerRadius: 25,
                    style: .continuous
                )
                    .fill(mainDark)
            )
            .frame(width: 70, height: 30, alignment: .trailing)
        } else {
            Button(action: {
               
            }
            ) {
                Text("تعديل").font(Font.custom("Tajawal", size: 16))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(
                    cornerRadius: 25,
                    style: .continuous
                )
                    .fill(grey)
            )
            .frame(width: 70, height: 30, alignment: .trailing)
        }
    }
    
    func convertToArabic(date: Date) -> String {
        let formatter = DateFormatter()
        
        //        formatter.dateFormat = "EEEE, d, MMMM, yyyy HH:mm a"
        formatter.dateFormat = "d"
        
        let day = formatter.string(from: date)
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        
        
        formatter.dateFormat = "  MMMM, "
        formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
        
        let month = formatter.string(from: date)
        
        
        return day + month + year
        
    }
    
    func appointmentsOnDate(date: Date) -> Bool {
        //        var thereIs: Bool = false
        let calender = Calendar.current
        
        for index in 0..<(aptVM.organAppointments.count){
            if(calender.isDate(aptVM.organAppointments[index].date!, inSameDayAs: date)){
                thereIS.thereIs = true
                return true;
            }
        }
        return false;
    }
    
}



class VAppointments : ObservableObject {
    let userID = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    @Published var currentDay: Date = Date()
    @Published var filteredAppointments = [retrievedAppointment]()
    
    @Published var organAppointments = [retrievedAppointment]()
    @Published var olderOA = [retrievedAppointment]()
    @Published var futureOA = [retrievedAppointment]()
    
    let dateFormatter: DateFormatter = DateFormatter()
    
    
    init() {
        organAppointments = self.getUserOA()
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        //        olderOA = self.getUserOlderOA()
    }
    
    func getUserOA() -> [retrievedAppointment] {
        olderOA.removeAll()
        futureOA.removeAll()
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        let past = self.dateFormatter.string(from: (Date() - 7))
        let future = self.dateFormatter.string(from: (Date() + 7))
        
        db.collection("volunteer").document(userID).collection("organAppointments").addSnapshotListener { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.organAppointments = documents.map { (queryDocumentSnapshot) -> retrievedAppointment in
                print("documents")
                let data = queryDocumentSnapshot.data()
                
                let duration = data["appointment_duration"] as! Int
                let type = data["type"] as? String ?? ""
                let hName = data["hospital_name"] as! String
                let exact = data["docID"] as! String
                let mainDoc = data["mainDocId"] as? String  ?? ""
                let hospitalId = data["hospital"] as! String
                let location = data["location"] as? String ?? ""
                
                let stamp1 = data["start_time"] as? Timestamp
                let startTime = stamp1?.dateValue()
                
                let stamp2 = data["end_time"] as? Timestamp
                let endTime = stamp2?.dateValue()
                
                
                let stamp3 = data["date"] as? Timestamp
                let aptDate = stamp3?.dateValue()
                
                var apt = retrievedAppointment()
                
                if(type == "organ"){
                    let organ = data["organ"] as! String
                    apt.organ = organ
                }
                
                apt.duration = duration
                apt.type = type
                apt.date = aptDate
                
                apt.appointmentID = exact
                apt.mainAppointmentID = mainDoc
                apt.endTime = endTime
                
                apt.startTime = startTime
                apt.hospitalID = hospitalId
                apt.hName = hName
                apt.hospitalLocation = location
                
                return apt
                
            }
            
        }
        
        for appointment in organAppointments {
            let ogDate = self.dateFormatter.string(from: appointment.date!)
            
            if(future < ogDate){
                self.futureOA.append(appointment)
            }
            
            if(past > ogDate){
                self.olderOA.append(appointment)
            }
        }
        
        return self.organAppointments
    }
    
    func filteringAppointments() -> [retrievedAppointment] {
        let calender = Calendar.current
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            if(!self.organAppointments.isEmpty){
                
                var filtered: [retrievedAppointment] = self.organAppointments.filter {
                    return calender.isDate($0.date!, inSameDayAs: self.currentDay)
                }
                
                
                DispatchQueue.main.async {
                    withAnimation {
                        self.filteredAppointments = filtered
                    }
                }
            }
            
        }
        return self.filteredAppointments
    }
    
    func getUserOlderOA() -> [retrievedAppointment] {
        
        db.collection("volunteer").document(userID).collection("organAppointments").addSnapshotListener { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.olderOA = documents.map { (queryDocumentSnapshot) -> retrievedAppointment in
                print("documents")
                let data = queryDocumentSnapshot.data()
                let duration = data["appointment_duration"] as! Int
                
                let type = data["type"] as! String
                let hName = data["hospital_name"] as! String
                let exact = data["docID"] as! String
                let mainDoc = data["mainDocId"] as! String
                let hospitalId = data["hospital"] as! String
                let location = data["location"] as! String
                
                let stamp1 = data["start_time"] as? Timestamp
                let startTime = stamp1!.dateValue()
                
                let stamp2 = data["end_time"] as? Timestamp
                let endTime = stamp2!.dateValue()
                
                
                let stamp3 = data["date"] as? Timestamp
                let aptDate = stamp3?.dateValue()
                
                var apt = retrievedAppointment()
                
                if(type == "organ"){
                    let organ = data["organ"] as! String
                    apt.organ = organ
                }
                
                apt.duration = duration
                apt.type = type
                apt.date = aptDate
                
                apt.appointmentID = exact
                apt.mainAppointmentID = mainDoc
                apt.endTime = endTime
                
                apt.startTime = startTime
                apt.hospitalID = hospitalId
                apt.hName = hName
                apt.hospitalLocation = location
                
                return apt
                
            }
            
        }
        
        return self.olderOA
    }
    
    func getUserFutureOA() -> [retrievedAppointment] {
        
        db.collection("volunteer").document(userID).collection("organAppointments").whereField("endDate", isGreaterThanOrEqualTo: getCurrentDate(time: "future")).addSnapshotListener { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.organAppointments = documents.map { (queryDocumentSnapshot) -> retrievedAppointment in
                print("documents")
                let data = queryDocumentSnapshot.data()
                let duration = data["appointment_duration"] as! Int
                
                let type = data["type"] as! String
                let hName = data["hospital_name"] as! String
                let exact = data["docID"] as! String
                let mainDoc = data["mainDocId"] as! String
                let hospitalId = data["hospital"] as! String
                let location = data["location"] as! String
                
                let stamp1 = data["start_time"] as? Timestamp
                let startTime = stamp1!.dateValue()
                
                let stamp2 = data["end_time"] as? Timestamp
                let endTime = stamp2!.dateValue()
                
                
                let stamp3 = data["date"] as? Timestamp
                let aptDate = stamp3?.dateValue()
                
                var apt = retrievedAppointment()
                
                if(type == "organ"){
                    let organ = data["organ"] as! String
                    apt.organ = organ
                }
                
                apt.duration = duration
                apt.type = type
                apt.date = aptDate
                
                apt.appointmentID = exact
                apt.mainAppointmentID = mainDoc
                apt.endTime = endTime
                
                apt.startTime = startTime
                apt.hospitalID = hospitalId
                apt.hName = hName
                apt.hospitalLocation = location
                
                return apt
                
            }
            
        }
        
        return self.organAppointments
    }
    
    func getCurrentDate(time: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        var currentDate = ""
        if(time == "past"){
            currentDate = dateFormatter.string(from: Date() - 7)
        }
        if(time == "future"){
            currentDate = dateFormatter.string(from: Date() + 7)
        }
        print("current date is \(currentDate)")
        return currentDate
        
    }
    
}

struct VAppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        VAppointmentsView(config: Configuration())
    }
}

func checkTimeStampOlder(date: String!) -> Bool {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.locale = Locale(identifier:"en_US_POSIX")
    let datecomponents = dateFormatter.date(from: date)
    
    let now = Date() - 7
    
    if (now >= datecomponents!) {
        return true
    } else {
        return false
    }
}

extension UIColor {
    var inverted: UIColor {
        var a: CGFloat = 0.0, r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0
        return getRed(&r, green: &g, blue: &b, alpha: &a) ? UIColor(red: 1.0-r, green: 1.0-g, blue: 1.0-b, alpha: a) : .black
    }
}
