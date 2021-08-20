//
//  SectionHeader.swift
//  CovidDataTracker
//
//  Created by iMac on 15.08.2021.
//

import UIKit

protocol SectionHeaderDelegate: AnyObject {
    func didTapAlphabetSort()
    func didTapCasesSort()
}

class SectionHeader: UITableViewHeaderFooterView {
    
    enum SortCase {
        case alphabet
        case newCases
    }
    
    private var sortState: SortCase = .newCases
    
    weak var delegate: SectionHeaderDelegate?

    private let alphabetSortButton: UIButton = {
        let button = UIButton()
        button.setTitle("A", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let casesSortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(systemName: "arrow.up.arrow.down"), for: .normal)
        button.tintColor = .systemGray3
        return button
    }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(alphabetSortButton)
        addSubview(casesSortButton)
        
        casesSortButton.isEnabled = false
        
        alphabetSortButton.addTarget(self, action: #selector(didTapAlphabetSort), for: .touchUpInside)
        casesSortButton.addTarget(self, action: #selector(didTapCasesSort), for: .touchUpInside)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func makeConstraints() {

        let size = 30
        
        alphabetSortButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(casesSortButton.snp.leading).inset(5)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(size)
        }
        
        casesSortButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(5)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(size)
        }
    }
    
    @objc private func didTapAlphabetSort() {
        update(state: .alphabet)
        delegate?.didTapAlphabetSort()
    }
    
    @objc private func didTapCasesSort() {
        update(state: .newCases)
        delegate?.didTapCasesSort()
    }
    
    private func update(state: SortCase) {
        
        switch state {
        case .alphabet:
            alphabetSortButton.setTitleColor(.systemGray3, for: .normal)
            casesSortButton.tintColor    = .black
            alphabetSortButton.isEnabled = false
            casesSortButton.isEnabled    = true
            
            
        case .newCases:
            alphabetSortButton.setTitleColor(.black, for: .normal)
            casesSortButton.tintColor    = .systemGray3
            alphabetSortButton.isEnabled = true
            casesSortButton.isEnabled    = false
            
        }
    }
    
}
