//
//  ViewController.swift
//  calendar-ios-16
//
//  Created by Victor Roldan on 7/06/22.
//

import UIKit

class ViewController: UIViewController {
    //Listado de fechas que quiers mostrar en el calendario
    let holidays = [
        "2024-01-01",
        "2024-01-08",
        "2024-03-25",
        "2024-03-28", 
        "2024-03-29",
    ]
    
    lazy var calendar : UICalendarView = {
        //Permite seleccionar solo una fecha
        let selectionBehaviour = UICalendarSelectionSingleDate(delegate: self)
        let locale = Locale(identifier: "en-EN")
        
        //Permitir seleccionar solo los próximos 15 días
        let fifteenDays = ((24 * 60) * 60) * 15
        let dateInterval = DateInterval(start: Date(), duration: TimeInterval(fifteenDays))
        
        let cal = UICalendarView()
        //Se debe setear el delegate para poder agregar las fechas marcadas.
        cal.delegate = self
        //cal.availableDateRange = dateInterval
        cal.backgroundColor = .white
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
            calendar.heightAnchor.constraint(equalToConstant: 420),
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

extension ViewController : UICalendarViewDelegate{
    
    //Este metodo toma fechas tipo string y las convierte a formato Date
    func dateFromString(stringDate: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        // Convert String to Date
        let newDate = dateFormatter.date(from: stringDate)
        return newDate
    }

    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {

        //Este método se llama por cada una de las fechas mostradas en el calendar
        //Entonces la idea es armar un listado de fechas y compararlas aquí
        guard let foundDate = holidays.map({dateFromString(stringDate: $0)})
            .filter({$0 == dateComponents.date})
            .first else { return nil }
        
        //Emojis debajo de cada fecha
        return .customView() {
            let emoji = UILabel()
            emoji.text = "🏝️"
            return emoji
        }
        
        /*
         //Puntos debajo de cada fecha
         return .default(color: .red, size: .large)
         
        
        //Imagen debajo de cada fecha.
        return UICalendarView.Decoration.image(
            UIImage(systemName: "heart.fill"),
            color: UIColor.red,
            size: .large
        )
        */
        
    }
    
    func calendarView(_ calendarView: UICalendarView, didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents) {
        print("se ejecuta cuando pasas de mes")
    }
}
