//
//  CountryViewController.swift
//  CovidDataTracker
//
//  Created by iMac on 10.08.2021.
//

import UIKit
import Charts
import SDWebImage

class CountryViewController: UIViewController {
    
    enum CountrySectionType: String {
        case info
        case todayData
        case calculated
    }
    
    let country: Country!
    var countryDaysData = [DayData]()
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifire)
        return tv
    }()
    
    private let BarChart: BarChartView = {
        let chartView = BarChartView()
        chartView.backgroundColor = .white
        
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(4, force: true)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor  = .black
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 9)
       // xAxis.drawGridLinesEnabled = true
//        xAxis.labelCount = 10
//        xAxis.granularity = 1
       // xAxis.centerAxisLabelsEnabled = true
        
        chartView.pinchZoomEnabled = true
        chartView.scaleYEnabled = true
        chartView.scaleXEnabled = true
        chartView.doubleTapToZoomEnabled = true
        
        return chartView
    }()

    let graphCountDays = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        BarChart.delegate = self
        
        configureTitle()
        configureTableView()
        
        fetchData()
        
        makeConstraints()
    }
    
    init(country: Country) {
        self.country = country
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureTitle() {
        
        title = country.name
        
        let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height:  40))
        tlabel.text = self.title

        tlabel.font = UIFont(name: "Helvetica-Bold", size: 16.0)
        tlabel.backgroundColor = .clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        self.navigationItem.titleView = tlabel
        
        
//        let titleView = TitleViewForNavigationBar(countryCode: country.code, title: country.name)
        //titleView.configure(countryCode: country.code, title: country.name)
//        let logo = UIImage(named: "pencil")
//        let imageView = UIImageView(image:logo)
//        self.navigationItem.titleView = imageView
//        let titleView = TitleViewForNavigationBar(frame: navigationItem.titleView?.bounds ?? CGRect())
//        self.navigationItem.titleView = titleView
//        titleView.layoutSubviews()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    private func fetchData() {
        
        APICaller.shared.getCountryData(code: country.code) { [weak self] (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let countryResponse):
                    
                    self?.countryDaysData = countryResponse.data.timeline ?? []
                    self?.createBarChart()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }
    
    private func makeConstraints() {
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func createBarChart() {
        
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width ))
        inputView.clipsToBounds = true

        
        BarChart.frame = inputView.frame
        inputView.addSubview(BarChart)
        tableView.tableHeaderView = inputView
        
        let decodeDate = DateFormatter.graphDecodeDateFormatter
        let encodeDate = DateFormatter.graphEncodeDateFormatter
        
        
        
        let firstTwentyDaysData = countryDaysData.prefix(graphCountDays).reversed()
        let newCases = firstTwentyDaysData.compactMap{ $0.new_confirmed ?? 100 }
        
        var entries: [BarChartDataEntry] = []
        
        if newCases.count > 1 {
            for index in (0...newCases.count-1).reversed() {
                let point = BarChartDataEntry(x: Double(index), y: Double(newCases[index]))

                entries.append(point)
            }
        }
        
        let valuesNumberFormatter = ChartValueFormatter(numberFormatter: NumberFormatter.decimalNumberFormatter)
        let dataSet = BarChartDataSet(entries: entries, label: "last 10 days")
        dataSet.setColor(.systemRed)
        dataSet.valueFormatter = valuesNumberFormatter

                
        //dataSet.valueFont = lineChartDataSet.valueFont.withSize(chartFontPointSize)
        //dataSet.colors = ChartColorTemplates.liberty()
        let xAxisValue = BarChart.xAxis
        xAxisValue.granularityEnabled = true
        xAxisValue.drawGridLinesEnabled = true
        xAxisValue.labelPosition = .bottom
        xAxisValue.labelCount = 10
        xAxisValue.granularity = 1
        
        //let data: LineChartData = LineChartData(dataSet: dataSet)
        let data: BarChartData = BarChartData(dataSet: dataSet)
        //data.setDrawValues(false)
        data.setValueFont(.boldSystemFont(ofSize: 9))
        //yAxis.setLabelCount(4, force: false)
        
        BarChart.data = data
        
        
//
//        let imageFlag = UIImageView(frame: CGRect(x: inputView.frame.minX+40, y: inputView.frame.minY+5, width: 64, height: 64))
//        let url = URL(string: APICaller.Constants.countryFlagAPI + country.code + APICaller.Constants.snihyFlag)
//        imageFlag.sd_setImage(with: url, placeholderImage: UIImage(systemName: "pencil"))
//        inputView.addSubview(imageFlag)
        

        let months = firstTwentyDaysData.compactMap{ encodeDate.string(from: decodeDate.date(from: $0.date) ?? Date())}

        BarChart.xAxis.valueFormatter = DefaultAxisValueFormatter { index, _  in
            return months[Int(index)]
            }
        
        
        BarChart.leftAxis.valueFormatter = DefaultAxisValueFormatter(block: { (index, _) -> String in
            return Int(index).getKString()
        })
        
        if BarChart.leftAxis.axisMinimum < 0 {
            BarChart.leftAxis.axisMinimum = 0
        }
        //BarChart.leftAxis.axisMinimum = Double(newCases.min() ?? 0) + 5000
        
        
        BarChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInOutQuart)
        
        print(country.code)
    }
    

}


extension CountryViewController: ChartViewDelegate {
    
    
}

extension CountryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 4
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifire, for: indexPath) as? DetailTableViewCell else {
            return UITableViewCell()
        }
        
        let section = indexPath.section
        
        switch section {
        case 0://Info
            
            let count = NumberFormatter.decimalNumberFormatter.string(from: NSNumber(value: country.population ?? 0))
            let viewModel = DetailCellViewModel(title: "population", subtitle: count)
            cell.configure(with: viewModel)
        case 1://Today
            let title = indexPath.row == 0 ? "deaths" : "confirmed"
            let count = (indexPath.row == 0 ? country.today.deaths : country.today.confirmed) ?? 0
            let countStr = NumberFormatter.decimalNumberFormatter.string(from: NSNumber(value: count))
            let viewModel = DetailCellViewModel(title: title, subtitle: countStr)
            cell.configure(with: viewModel)
        case 2://Calculated
            var title: String?
            var count: Float?
            var countString: String?
            
            switch indexPath.row {
            case 0: //today
                title = "death_rate"
                count = country.latest_data.calculated.death_rate
                countString = String(format: "%.1f", count ?? 0.0) + " %"
            case 1:
                title = "recovery_rate"
                count = country.latest_data.calculated.recovery_rate
                countString = String(format: "%.1f", count ?? 0.0) + " %"
            case 2:
                title = "recovered_vs_death_ratio"
                count = country.latest_data.calculated.recovered_vs_death_ratio
                countString = String(format: "%.1f", count ?? 0.0)
            case 3:
                title = "cases_per_million_population"
                count = country.latest_data.calculated.cases_per_million_population
                countString = NumberFormatter.decimalNumberFormatter.string(from: NSNumber(value: count ?? 0.0))
            default:
                break
            }
            
            let viewModel = DetailCellViewModel(title: title, subtitle: countString)
            cell.configure(with: viewModel)
        default:
            break
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Info"
        case 1: return "Today"
        case 2: return "Calculated"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let sectionHeader = view as? UITableViewHeaderFooterView else { return }
        sectionHeader.textLabel?.textAlignment = .center
        sectionHeader.textLabel?.textColor = .systemBlue
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
