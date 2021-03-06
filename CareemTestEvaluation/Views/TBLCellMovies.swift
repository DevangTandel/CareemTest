//
//  TBLCellMovies.swift
//  CareemTestEvaluation
//
//  Created by Silver Shark on 16/05/18.
//  Copyright © 2018 RudraApps. All rights reserved.
//

/*With following SOLID principal that state No Model should interact with Views
 Views can be interract with viewcontrollers
 */

import UIKit

class TBLCellMovies: UITableViewCell {

    @IBOutlet weak var imgMoviePoster: UIImageView!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblMoviename: UILabel!
    @IBOutlet weak var lblMoviewDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
