//
//  FullScreenCalendarViewController.swift
//  calendar-ios-16
//
//  Created by Victor Roldan on 7/06/22.
//

import UIKit

protocol FullScreenCalendarProtocol : AnyObject{
    func didSelect(dates : [Date]?)
}

class FullScreenCalendarViewController: UIViewController {
    weak var delegate : FullScreenCalendarProtocol?
    var dates : [Date] = []
    
    lazy var closeButton : UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var calendar : UICalendarView = {
        //Para seleccionar solo una fecha
        //let selectionBehaviour = UICalendarSelectionSingleDate(delegate: self)
        
        //Múltimple selección de fechas
        let selectionBehaviour = UICalendarSelectionMultiDate(delegate: self)
        let locale = Locale(identifier: "en-EN")
        
        //Permitir seleccionar fechas hasta máximo 15 días.
        let fifteenDays = ((24 * 60) * 60) * 15
        let dateInterval = DateInterval(start: Date(), duration: TimeInterval(fifteenDays))
        
        let cal = UICalendarView()
        //cal.availableDateRange = dateInterval
        cal.layer.cornerRadius = 20
        cal.locale = locale
        cal.selectionBehavior = selectionBehaviour
        cal.translatesAutoresizingMaskIntoConstraints = false
        return cal
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(calendar)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendar.heightAnchor.constraint(equalToConstant: 300),
            
            //close button
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    @objc func closeButtonPressed(){
        delegate?.didSelect(dates: dates)
        dismiss(animated: true)
    }
}

extension FullScreenCalendarViewController : UICalendarSelectionSingleDateDelegate, UICalendarSelectionMultiDateDelegate{
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        //no se usa cuando es multi dates
        print("selected Date: ", dateComponents?.date)
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        if let date = dateComponents.date{
            dates.append(date)
        }
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
        if let date = dateComponents.date{
            dates.removeAll(where: {date == $0})
        }
    }
}
