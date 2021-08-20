//
//  MainCountryTableViewCell.swift
//  CovidDataTracker
//
//  Created by iMac on 07.08.2021.
//

import UIKit
import SDWebImage

class MainCountryTableViewCell: UITableViewCell {

    static let identifire = "MainCountryTableViewCell"
    
    private let countryNamelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let countryConfirmedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(countryNamelabel)
        contentView.addSubview(countryConfirmedLabel)
        contentView.addSubview(flagImageView)
        contentView.clipsToBounds = true
        
        accessoryType = .disclosureIndicator
        makeConstraints()
    }
    
    private func makeConstraints() {
        
        flagImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(5)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(contentView.height)
        }
        
        countryNamelabel.snp.makeConstraints { (make) in
            make.leading.equalTo(flagImageView.snp.trailing).offset(5)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.65)
        }
        
        countryConfirmedLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        flagImageView.image = nil
        countryNamelabel.text = nil
        countryConfirmedLabel.text = nil
    }
    
    
    func configure(with viewModel: CountryViewModel) {
        countryNamelabel.text = viewModel.name
        let newCases = NumberFormatter.decimalNumberFormatter.string(from: NSNumber(value: viewModel.newConfirmed)) ?? "0"
        countryConfirmedLabel.text = "+ " + newCases
        flagImageView.sd_setImage(with: viewModel.flagURL, placeholderImage: UIImage(systemName: "flag.slash"))
    }

}
