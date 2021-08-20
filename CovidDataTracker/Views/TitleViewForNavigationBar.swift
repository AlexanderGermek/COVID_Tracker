//
//  TitleViewForNavigationBar.swift
//  CovidDataTracker
//
//  Created by iMac on 12.08.2021.
//

import UIKit
import SDWebImage

class TitleViewForNavigationBar: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    
//    public func configure(countryCode: String, title: String) {
//        label.text = title
//
//        let url = URL(string: APICaller.Constants.countryFlagAPI + countryCode + APICaller.Constants.snihyFlag)
//
//        imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "flag.slash"), completed: { [weak self] _,_,_,_ in
//            self?.layoutSubviews()
//        })
//
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //makeConstraints()
        
        addSubview(imageView)
        addSubview(label)
        makeConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(countryCode: String, title: String) {
        self.init(frame: CGRect())
        
        label.text = title
        
        let url = URL(string: APICaller.Constants.countryFlagAPI + countryCode + APICaller.Constants.snihyFlag)
        
        imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "flag.slash"), completed: { [weak self] _,_,_,_ in
            self?.layoutSubviews()
        })
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        imageView.frame = CGRect(x: 10, y: 0, width: 64, height: height)
//
//        label.frame  = CGRect(x: 74, y: 0, width: width - 74, height: height)
//    }
    
    private func makeConstraints() {

        imageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(5)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(64)
        }

        label.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.snp.trailing).inset(5)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(width-74)
        }
    }
}
