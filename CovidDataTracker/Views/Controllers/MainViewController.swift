//
//  MainViewController.swift
//  CovidDataTracker
//
//  Created by iMac on 07.08.2021.
//

import UIKit
import SnapKit
import Charts
import SDWebImage

class MainViewController: UIViewController {
    
    private var countries = [Country]()
    private var globalDays = [DayData]()
    
    private let LineChart: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .white

        chartView.rightAxis.enabled = false

        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(4, force: true)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor  = .black

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 10)

        return chartView
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
        //xAxis.centerAxisLabelsEnabled = true

        chartView.pinchZoomEnabled = true
        chartView.scaleYEnabled = true
        chartView.scaleXEnabled = true
        chartView.doubleTapToZoomEnabled = true
        
        return chartView
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.register(MainCountryTableViewCell.self, forCellReuseIdentifier: MainCountryTableViewCell.identifire)
        return tv
    }()
    
    private let headerForSection: SectionHeader = {
        
        let header = SectionHeader()
        
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 9)
        header.textLabel?.textAlignment = .left
        header.textLabel?.adjustsFontSizeToFitWidth = true
        return header
    }()
    
    let graphCountDays = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LineChart.delegate        = self
        BarChart.delegate         = self
        headerForSection.delegate = self

        createUIMenu()
        
        configureTableView()
        
        makeConstraints()
        
        fetchCountries()
    }
    
    //MARK: - Private functions
    private func createUIMenu() {
        
        let menuItems: [UIAction] = [
            
            UIAction(title: "Line chart",
                     image: UIImage(systemName: "bolt.horizontal"),
                     handler: { [weak self] (action) in
                        self?.createLineChart()
                     }),
            
            UIAction(title: "Bar chart",
                     image: UIImage(systemName: "chart.bar"),
                     handler: { [weak self] (action) in
                        self?.createBarChart()
                     })
        ]

        let menu = UIMenu(title: "Select chart", image: nil, identifier: nil, options: [], children: menuItems)
        
        let barButton = UIBarButtonItem(title: "",
                                        image: UIImage(systemName: "chart.bar.xaxis"),
                                        primaryAction: nil,
                                        menu: menu)
        barButton.tintColor = .black
        navigationItem.rightBarButtonItem = barButton
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
          make.edges.equalToSuperview()
        }
    }
    
    private func configureTableView() {
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func fetchCountries() {
        
        let group = DispatchGroup()
        
        group.enter()
        group.enter()
        
        APICaller.shared.getAllCountriesData { [weak self] result in
            
            switch result {
            case .success(let countries):
                self?.countries = countries.sorted(by: { $1.today.confirmed ?? 0 < $0.today.confirmed ?? 0 })
                group.leave()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getGlobalData { [weak self] (result) in
            
            switch result {
            case .success(let days):
                self?.globalDays = days
                group.leave()
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.createBarChart()
            self?.tableView.reloadData()
            
        }
    }
    
    private func createBarChart() {
        tableView.tableHeaderView = nil
        
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width ))
        inputView.clipsToBounds = true
 
        // Configure chart:
        BarChart.frame = inputView.frame
        inputView.addSubview(BarChart)
        
        //Date Formatters:
        let decodeDate = DateFormatter.graphDecodeDateFormatter
        let encodeDate = DateFormatter.graphEncodeDateFormatter
        
        //Configure data:
        let firstTwentyDaysData = globalDays.prefix(graphCountDays).reversed()
        let newCasesData = firstTwentyDaysData.compactMap{ $0.new_confirmed ?? 0 }

        var entries: [BarChartDataEntry] = []
        
        for index in (0...newCasesData.count-1).reversed() {
            let point = BarChartDataEntry(x: Double(index), y: Double(newCasesData[index]))
            entries.append(point)
        }
        
        let valuesNumberFormatter = ChartValueFormatter(numberFormatter: NumberFormatter.decimalNumberFormatter)
        let dataSet = BarChartDataSet(entries: entries, label: "New World Cases")
        dataSet.setColor(.systemRed)
        dataSet.valueFormatter = valuesNumberFormatter
                
        let data: BarChartData = BarChartData(dataSet: dataSet)
        data.setValueFont(.boldSystemFont(ofSize: 9))
        
        BarChart.data = data

        let xAxisValue = BarChart.xAxis
        let monthsLabels = firstTwentyDaysData.compactMap{ encodeDate.string(from: decodeDate.date(from: $0.date) ?? Date())}
        
        xAxisValue.valueFormatter = DefaultAxisValueFormatter { index, _ in
                return monthsLabels[Int(index)]
            }
        
        xAxisValue.granularityEnabled = true
        xAxisValue.drawGridLinesEnabled = true
        xAxisValue.labelPosition = .bottom
        xAxisValue.labelCount = 10
        xAxisValue.granularity = 1
        
        BarChart.leftAxis.valueFormatter = DefaultAxisValueFormatter(block: { (index, _) -> String in
                return Int(index).getKString()
            })
        //BarChart.leftAxis.drawLabelsEnabled = false
        
        
        tableView.tableHeaderView = BarChart
        BarChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInOutQuart)
    }

    private func createLineChart() {
        tableView.tableHeaderView = nil
        
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width ))
        inputView.clipsToBounds = true
        
        // Configure chart:
        LineChart.frame = inputView.frame
        inputView.addSubview(LineChart)
        
        //Date Formatters:
        let decodeDate = DateFormatter.graphDecodeDateFormatter
        let encodeDate = DateFormatter.graphEncodeDateFormatter

        
        //Configure data:
        let firstTwentyDaysData = globalDays.prefix(graphCountDays).reversed()
        let newCasesData = firstTwentyDaysData.compactMap{ $0.new_confirmed ?? 0 }

        var entries: [ChartDataEntry] = []

        for index in (0...newCasesData.count-1) {
            let point = ChartDataEntry(x: Double(index), y: Double(newCasesData[index]))
            entries.append(point)
        }
        
        let valuesNumberFormatter = ChartValueFormatter(numberFormatter: NumberFormatter.decimalNumberFormatter)
        let dataSet = LineChartDataSet(entries: entries, label: "New World Cases")
        
        dataSet.setColor(.systemRed)
        dataSet.drawCirclesEnabled = false
        dataSet.mode               = .cubicBezier
        dataSet.lineWidth          = 2
        dataSet.fill               = Fill(color: .red)
        dataSet.fillAlpha          = 0.7
        dataSet.drawFilledEnabled  = true
        dataSet.valueFormatter = valuesNumberFormatter
                
        let data: LineChartData = LineChartData(dataSet: dataSet)
        data.setValueFont(.boldSystemFont(ofSize: 9))
        
        LineChart.data = data

        
        let xAxisValue = LineChart.xAxis
        let monthsLabels = firstTwentyDaysData.compactMap{ encodeDate.string(from: decodeDate.date(from: $0.date) ?? Date())}
        xAxisValue.valueFormatter = DefaultAxisValueFormatter { index, _ in
                return (monthsLabels[Int(index)])
            }
        
        xAxisValue.granularityEnabled = true
        xAxisValue.drawGridLinesEnabled = true
        xAxisValue.labelPosition = .bottom
        xAxisValue.labelCount = 10
        xAxisValue.granularity = 1
        //xAxisValue.centerAxisLabelsEnabled = true
        
        LineChart.leftAxis.valueFormatter = DefaultAxisValueFormatter(block: { (index, _) -> String in
                return Int(index).getKString()
            })
        
        tableView.tableHeaderView = LineChart
        
        LineChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInOutQuart)
    }

}


extension MainViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainCountryTableViewCell.identifire, for: indexPath) as? MainCountryTableViewCell else {
            return UITableViewCell()
        }
        
        let country = countries[indexPath.row]
        
        let countryViewModel = CountryViewModel(with: country)
        
        cell.configure(with: countryViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if countries.count > 0 {
            let updated_at = DateFormatter.simpleDateFormatter.string(from: countries[0].updated_at)
            return "New Cases, Updated At \(updated_at)"
        } else {
            return ""
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let country = countries[indexPath.row]
        
        let countryVC = CountryViewController(country: country)
        navigationController?.pushViewController(countryVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerForSection
    }
}


extension MainViewController: SectionHeaderDelegate {
    func didTapAlphabetSort() {
        
        countries.sort{ $0.name < $1.name }
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadSections([0], with: .automatic)
        }
        
    }
    
    func didTapCasesSort() {
        countries.sort{ $1.today.confirmed ?? 0 < $0.today.confirmed ?? 0 }
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadSections([0], with: .automatic)
        }
    }
    
    
}
