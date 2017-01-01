//
//  friendCellTableViewCell.swift
//  CloudRook
//
//  Created by Brad Caldwell on 1/1/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class friendCellTableViewCell: UITableViewCell {

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(user:User){
        self.friendName.text = user.name
        if let url = user.picUrl{
            print(url)
            let stringUrl = String(describing: url)
                        Alamofire.request(stringUrl).responseImage { response in
                           // debugPrint(response)
            
                           // print(response.request)
                           // print(response.response)
                           // debugPrint(response.result)
            
                            if let image = response.result.value {
                                print("image downloaded: \(image)")
                                self.friendImage.image = image
                            }
                            else{
                                self.friendImage.image = UIImage(named: "Black1")
                            }
                        }

        }
        else{
              self.friendImage.image = UIImage(named: "Black1")
        }
        
//            Alamofire.request("").responseImage { response in
//                debugPrint(response)
//                
//                print(response.request)
//                print(response.response)
//                debugPrint(response.result)
//                
//                if let image = response.result.value {
//                    print("image downloaded: \(image)")
//                    self.friendImage.image = image
//                }
//            }
//            
//        
        

        
        
    }
    
}
