import Foundation
import UIKit
import HorizonCalendar

final class CalendarViewController: UIViewController {
    
    @IBOutlet var calendarUIView: UIView!
    private var selectedDay: Day?
    
    @IBOutlet weak var selectedDayLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        let calendarView = CalendarView(initialContent: makeContent())
        self.view.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: calendarUIView.layoutMarginsGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: calendarUIView.layoutMarginsGuide.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: calendarUIView.layoutMarginsGuide.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: calendarUIView.layoutMarginsGuide.bottomAnchor),
        ])
        
        calendarView.daySelectionHandler = { [weak self] day in
            guard let self = self else { return }
            self.selectedDay = day
            let newContent = self.makeContent()
            calendarView.setContent(newContent)
            var dc = DateComponents()
            dc.year = self.selectedDay?.components.year
            dc.month = self.selectedDay?.components.month
            dc.day = self.selectedDay?.components.day
            dc.timeZone = TimeZone(abbreviation: "EST")
            let dcDate = self.calendar.date(from: dc)!
            print (DateFormatter().getFullDate(from: dcDate))
            NotificationCenter.default.post(name:  .setEventDate,
                                            object: nil, userInfo: ["selectedDate": dcDate])
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    private lazy var calendarView = CalendarView(initialContent: makeContent())
    private lazy var calendar = Calendar(identifier: .gregorian)
    private lazy var dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "EEEE, MMM d, yyyy",
            options: 0,
            locale: calendar.locale ?? Locale.current)
        return dateFormatter
    }()
    
    
    private func makeContent() -> CalendarViewContent {
        let startDate = calendar.date(from: DateComponents(year: 2020, month: 01, day: 01))!
        let endDate = calendar.date(from: DateComponents(year: 2021, month: 12, day: 31))!
        
        let selectedDay = self.selectedDay
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()))
            
            .withInterMonthSpacing(24)
            .withVerticalDayMargin(8)
            .withHorizontalDayMargin(8)
            
            .withDayItemProvider { day in
                let isSelected = day == selectedDay
                
                return CalendarItem<DayView, Day>(
                    viewModel: day,
                    styleID: isSelected ? "Selected" : "Default",
                    buildView: { DayView(isSelectedStyle: isSelected) },
                    updateViewModel: { [weak self] dayView, day in
                        dayView.dayText = "\(day.day)"
                        
                        if let date = self?.calendar.date(from: day.components) {
                            dayView.dayAccessibilityText = self?.dayDateFormatter.string(from: date)
                        } else {
                            dayView.dayAccessibilityText = nil
                        }
                    },
                    updateHighlightState: { dayView, isHighlighted in
                        dayView.isHighlighted = isHighlighted
                })
        }
    }
    
}


// MARK: - DayView
final class DayView: UIView {
    
    // MARK: Lifecycle
    init(isSelectedStyle: Bool) {
        super.init(frame: .zero)
        
        addSubview(dayLabel)
        
        layer.borderColor = UIColor.systemTeal.cgColor
        layer.borderWidth = isSelectedStyle ? 2 : 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    var dayText: String {
        get { dayLabel.text ?? "" }
        set { dayLabel.text = newValue }
    }
    
    var dayAccessibilityText: String?
    
    var isHighlighted = false {
        didSet {
            updateHighlightIndicator()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dayLabel.frame = bounds
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
    
    // MARK: Private
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        if #available(iOS 13.0, *) {
            label.textColor = .label
        } else {
            label.textColor = .black
        }
        return label
    }()
    
    private func updateHighlightIndicator() {
        backgroundColor = isHighlighted ? UIColor.black.withAlphaComponent(0.1) : .clear
    }
}

// MARK: UIAccessibility
extension DayView {
    
    override var isAccessibilityElement: Bool{
        get { true }
        set { }
    }
    
    //в extension нельзя обычные свойства задавать
    
    override var accessibilityLabel: String? {
        get { dayAccessibilityText ?? dayText }
        set { }
    }
    
}
