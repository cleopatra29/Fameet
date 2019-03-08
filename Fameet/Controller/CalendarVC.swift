//
//  CalendarViewController.swift
//  FinalChallengeVessel
//
//  Created by Terretino on 31/01/19.
//  Copyright © 2019 Terretino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class CalendarVC: UIViewController {
    @IBOutlet weak var datePickedTableView: UITableView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var datesYouPickedLabel: UILabel!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var prevMonthBtn: UIButton!
    @IBOutlet weak var nextMonthBtr: UIButton!
    
    let MasterUser = Auth.auth().currentUser!.uid as String
    var MasterFamily = String()
    
    var datePicked : [NSDate] = []
    var dateModel = DateModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.shapingView()
        datePickedTableView.tableFooterView = UIView()
        delegateTableViewAndCollectionView()
        dateModel.februaryAmbiguousDate()
        dateModel.setupTodayDate()
        setUpView()
        readFreeTime()
        prevMonthBtn.isEnabled = false
    }
    
    func setUpView() {
        monthLabel.font = UIFont(name: "SF-Pro-Display-Medium", size: 20.00)
        monthLabel.text = "\(dateModel.monthsArray[dateModel.currentMonthIndex - 1]) \(dateModel.currentYear)"
    }
    
    func delegateTableViewAndCollectionView() {
        datePickedTableView.delegate = self
        datePickedTableView.dataSource = self
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
    }
    
    @IBAction func nextMonthButton(_ sender: Any) {
        if dateModel.currentMonthIndex > 11 {
            dateModel.currentMonthIndex = 0
            dateModel.currentYear += 1
        }
        
        if dateModel.currentMonthIndex == dateModel.presentMonthIndex - 1 && dateModel.currentYear == dateModel.presentYear {
            prevMonthBtn.isEnabled = false
        } else {
            prevMonthBtn.isEnabled = true
        }
        monthLabel.text="\(dateModel.monthsArray[dateModel.currentMonthIndex]) \(dateModel.currentYear)"
        dateModel.didChangeMonth(monthIndex: dateModel.currentMonthIndex, year: dateModel.currentYear)
        calendarCollectionView.reloadData()
        print("Date : \(self.dateModel.todaysDate)")
        print("MONTH : \(self.dateModel.presentMonthIndex)")
        print("YEAr : \(self.dateModel.presentYear)")
    }
    
    @IBAction func prevMonthButton(_ sender: Any) {
        dateModel.currentMonthIndex -= 2
        if dateModel.currentMonthIndex < 0 {
            dateModel.currentMonthIndex = 11
            dateModel.currentYear -= 1
        }
        if dateModel.currentMonthIndex == dateModel.presentMonthIndex - 1 && dateModel.currentYear == dateModel.presentYear {
            prevMonthBtn.isEnabled = false
        } else {
            prevMonthBtn.isEnabled = true
        }
        
        monthLabel.text = "\(dateModel.monthsArray[dateModel.currentMonthIndex]) \(dateModel.currentYear)"
        dateModel.didChangeMonth(monthIndex: dateModel.currentMonthIndex, year: dateModel.currentYear)
        calendarCollectionView.reloadData()
        print("Date : \(self.dateModel.todaysDate)")
        print("MONTH : \(self.dateModel.presentMonthIndex)")
        print("YEAr : \(self.dateModel.presentYear)")
    }
    
    func readFreeTime(){
        let masterUserRef = Firestore.firestore().collection("family-collection").document(MasterFamily).collection("family-member").document(MasterUser)
        masterUserRef.collection("free-time").getDocuments(completion: { (snapshot, error) in
            if error != nil{
                return print(error!)
            } else {
                for document in snapshot!.documents {
                    let freeTimeId = document.documentID
                    guard
                        let day = document.data() ["date"] as? Int ,
                        let month = document.data() ["month"] as? Int,
                        let year = document.data() ["year"] as? Int
                        else {return}
                    
                    if year >= self.dateModel.presentYear {
                        if year >= self.dateModel.presentYear || month >= self.dateModel.presentMonthIndex {
                            if year >= self.dateModel.presentYear || month >= self.dateModel.presentMonthIndex || day >= self.dateModel.todaysDate {
                                let datestring : NSDate = NSDate(dateString: "\(day)-\(month)-\(year)")
                                self.datePicked.append(datestring)
                            } else {
                                masterUserRef.collection("free-time").document(freeTimeId).delete()
                            }
                        } else {
                            masterUserRef.collection("time").document(freeTimeId).delete()
                        }
                    } else {
                        masterUserRef.collection("free-time").document(freeTimeId).delete()
                    }
                }
                self.datePicked.sort(by: { $0.compare($1 as Date) == ComparisonResult.orderedAscending })
            }
            
            //self.datePicked.sort()
            self.calendarCollectionView.reloadData()
            self.datePickedTableView.reloadData()
            print("MONTH : \(self.dateModel.presentMonthIndex)")
            print("YEAr : \(self.dateModel.presentYear)")
        })
    }
    
    func addFreeTime(freeTimeId: String, date : Int, month : Int, year : Int) {
        let dict : [String: Any] = [ "date" : date, "month" : month, "year" : year]
        Firestore.firestore().collection("family-collection").document(MasterFamily).collection("family-member").document(MasterUser).collection("free-time").document(freeTimeId).setData(dict)
    }
    
    func deleteFreeTime(freeTimeId : String){
        Firestore.firestore().collection("family-collection").document(MasterFamily).collection("family-member").document(MasterUser).collection("free-time").document(freeTimeId).delete()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let target = segue.destination as? FamilyVC else {return}
        target.MasterFamily = MasterFamily as String
    }
    
     
    
    @IBAction func submitFreeTimeAct(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension CalendarVC: UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datePicked.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableDatePickedReuseIdentifier", for: indexPath) as! CalendarTableViewCell
        cell.datePickedView.shapingView()
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "dd-MM-yyy"
        
        let myString = formatter.string(from: datePicked[indexPath.row] as Date) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd"
        let dateString = formatter.string(from: yourDate!)
        cell.datePicked.text = dateString
        
        formatter.dateFormat = "MMMM"
        let monthString = formatter.string(from: yourDate!)
        cell.monthPicked.text = monthString
        
        formatter.dateFormat = "YYYY"
        let yearString = formatter.string(from: yourDate!)
        cell.yearPicked.text = yearString
        
        cell.datePickedView.backgroundColor = UIColor.datePickedViewColor
        tableView.allowsSelection = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateModel.numberOfDaysInMonth[dateModel.currentMonthIndex - 1] + dateModel.firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateReuseIdentifier", for: indexPath) as! CalendarCollectionViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.dateLabel.textColor = .black
        cell.layer.cornerRadius = 13.5
        
        if indexPath.item <= dateModel.firstWeekDayOfMonth - 2 {
            cell.isHidden=true
            cell.dateLabel.text = "1"
        } else {
            let calcDate = indexPath.row - dateModel.firstWeekDayOfMonth+2
            cell.isHidden=false
            switch indexPath.row {
            case 0,6,7,13,14,20,21,27,28,34,35 :
                cell.dateLabel.textColor = .red
            default:
                break
            }
            cell.dateLabel.text = "\(calcDate)"
            if calcDate < dateModel.todaysDate && dateModel.currentYear == dateModel.presentYear && dateModel.currentMonthIndex == dateModel.presentMonthIndex {
                cell.isUserInteractionEnabled = false
                cell.dateLabel.textColor = .lightGray
            } else {
                cell.isUserInteractionEnabled = true
            }
        }
        let lbl = cell.dateLabel.text!
        let cellDate = NSDate(dateString: "\(lbl)-\(dateModel.currentMonthIndex)-\(dateModel.currentYear)")
        for date in datePicked {
            if date == cellDate {
                cell.animatingColoring(0, .yellow)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCollectionViewCell
        let dateFull = cell.dateLabel.text! + "-\(dateModel.currentMonthIndex)-\(dateModel.currentYear)"
        let date : Int = Int(cell.dateLabel.text!)!
        let month : Int = dateModel.currentMonthIndex
        let year : Int = dateModel.currentYear
        
        if cell.backgroundColor != .yellow {
            cell.animatingColoring(0, .yellow)
            datePicked.append(NSDate(dateString: "\(date)-\(month)-\(year)"))
            addFreeTime(freeTimeId: dateFull, date: date, month: month, year: year)
            self.datePicked.sort(by: { $0.compare($1 as Date) == ComparisonResult.orderedAscending })
            datePickedTableView.reloadData()
        }
        else {
            cell.animatingColoring(0, .clear)
            
            while let dateIndex = datePicked.index(of: NSDate(dateString: "\(date)-\(month)-\(year)")) {
                datePicked.remove(at: dateIndex)
                deleteFreeTime(freeTimeId: dateFull)
            }
            self.datePicked.sort(by: { $0.compare($1 as Date) == ComparisonResult.orderedAscending })
            datePickedTableView.reloadData()
        }
    }
}


