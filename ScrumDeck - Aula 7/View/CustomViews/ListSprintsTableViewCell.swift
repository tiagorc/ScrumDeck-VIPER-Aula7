//
//  ListSprintsTableViewCell.swift
//  ScrumDeck - Aula 7
//
//  Created by Euler Carvalho on 17/06/21.
//

import UIKit

class ListSprintsTableViewCell: UITableViewCell {
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myImageVIew: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        myImageVIew.layer.cornerRadius = myImageVIew.bounds.height/2
    }

    func bind(sprint: Sprint) {
        myLabel.text = sprint.nome
        myImageVIew.image = UIImage.imageWith(name: sprint.nome)
    }
}
