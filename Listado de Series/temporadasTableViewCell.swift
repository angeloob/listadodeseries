//
//  temporadasTableViewCell.swift
//  Listado de Series
//
//  Created by Angel Olvera on 2/26/19.
//  Copyright © 2019 Angel Olvera. All rights reserved.
//

import UIKit
/**
 parte visual de la tabla, lo que contiene la celda
 */
class temporadasTableViewCell: UITableViewCell {
    
    @IBOutlet weak var season: UILabel!
    @IBOutlet weak var descripcion: UITextView!
    @IBOutlet weak var portada: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
