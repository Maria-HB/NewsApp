//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Maria Habib on 28/10/2021.
//

import UIKit

class NewsTableViewCell: BaseTableViewCell {

    static let identifier = "NewsTableViewCell"

    var viewModel: NewsCellViewModel! {
        didSet {
            self.bind()
        }
    }
    
    private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .secondarySystemBackground
        
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        
        return label
    }()
    
    private var detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = contentSpacing / 2
        
        return stackView
    }()

    override func prepareForReuse() {
         super.prepareForReuse()
        self.titleLabel .text = nil
        self.descriptionLabel.text = nil
        self.thumbnailImageView.image = nil
    }
    
    override func configureUI() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(self.thumbnailImageView)
        self.contentView.addSubview(self.detailsStackView)
        self.thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        self.detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.thumbnailImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: contentSpacing).isActive = true
        self.thumbnailImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.thumbnailImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
       // self.thumbnailImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.thumbnailImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: contentSpacing).isActive = true
        
        self.detailsStackView.addArrangedSubview(titleLabel)
        self.detailsStackView.addArrangedSubview(descriptionLabel)
        
        self.detailsStackView.leadingAnchor.constraint(equalTo: self.thumbnailImageView.trailingAnchor, constant: contentSpacing).isActive = true
        self.detailsStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -contentSpacing).isActive = true
        self.detailsStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: contentSpacing).isActive = true
        self.detailsStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.detailsStackView.setContentCompressionResistancePriority(.required, for: .vertical)

    }
    
    private func bind() {
       self.titleLabel.text = self.viewModel.titleText
       self.descriptionLabel.text = self.viewModel.description
        //set image later
        if let data = viewModel.imageData {
                self.thumbnailImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            
            NetworkManager.urlRequest(url: url) { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = UIImage(data: data)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

}
