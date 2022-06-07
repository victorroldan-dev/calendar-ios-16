//
//  ViewController.swift
//  calendar-ios-16
//
//  Created by Victor Roldan on 7/06/22.
//

import UIKit

class ViewController: UIViewController {
    lazy var calendar : UICalendarView = {
        //Permite seleccionar solo una fecha
        let selectionBehaviour = UICalendarSelectionSingleDate(delegate: self)
        let locale = Locale(identifier: "en-EN")
        
        //Permitir seleccionar solo los próximos 15 días
        let fifteenDays = ((24 * 60) * 60) * 15
        let dateInterval = DateInterval(start: Date(), duration: TimeInterval(fifteenDays))
        
        let cal = UICalendarView()
        //cal.availableDateRange = dateInterval
        cal.backgroundColor = .systemRed
        cal.layer.cornerRadius = 20
        cal.locale = locale
        cal.selectionBehavior = selectionBehaviour
        cal.translatesAutoresizingMaskIntoConstraints = false
        return cal
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.9)
        view.addSubview(calendar)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendar.heightAnchor.constraint(equalToConstant: 300),
        ])
        
    }
    @IBAction func openCalendarPressed(_ sender: Any) {
        let vc = FullScreenCalendarViewController()
        vc.delegate = self
        if let presentation = vc.presentationController as? UISheetPresentationController{
            presentation.detents = [.medium()]
        }
        present(vc, animated: true)
    }
}

extension ViewController : UICalendarSelectionSingleDateDelegate{
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        print("selected Date: ", dateComponents?.date)
    }
}

extension ViewController : FullScreenCalendarProtocol{
    func didSelect(dates: [Date]?) {
        print("selecte full: ", dates)
    }
}
