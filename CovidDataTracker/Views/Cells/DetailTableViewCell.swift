//
//  DetailTableViewCell.swift
//  CovidDataTracker
//
//  Created by iMac on 11.08.2021.
//

import UIKit
import SnapKit

class DetailTableViewCell: UITableViewCell {
    
    static let identifire = "DetailTableViewCell"
    
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        //label.backgroundColor = .green
        return label
    }()
    
    private let numberOfOptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .right
        //label.backgroundColor = .red
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(optionLabel)
        contentView.addSubview(numberOfOptionLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let offset = CGFloat(10)

        optionLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(offset)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(contentView.width*0.65 - offset)
        }
        
        numberOfOptionLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(offset)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(contentView.width*0.35 - offset)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        optionLabel.text = nil
        numberOfOptionLabel.text = nil
    }
    
    func configure(with viewModel: DetailCellViewModel) {
        optionLabel.text = viewModel.title
        numberOfOptionLabel.text = viewModel.subtitle
        
    }
    
}
