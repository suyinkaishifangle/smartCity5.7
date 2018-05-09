//
//  HomeSection2TableViewCell.swift
//  smartCity
//
//  Created by MuY on 2018/4/5.
//  Copyright © 2018年 MuY. All rights reserved.
//

import UIKit

class HomeSection3TableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var parkingNumArray = [(image:UIImage,title:String)]()
    var tagArray = [(color:UIColor,title:String)]()
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var parkingNumCollectionView: UICollectionView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
    }
    func showData(model:ParkingList){
        parkingNumCollectionView.register(UINib.init(nibName: "HomeTagCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "HomeTagCollectionViewCell")
        tagCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        let data = try? Data.init(contentsOf: URL.init(string: model.imageUrl)!)
            if data != nil{
                headImage.image = UIImage.init(data: data!)
            }
        titleLabel.text = model.parkingName
        distanceLabel.text = "\(model.distance)m"
        var price = ""
        price += "停车：\(model.parkingPrice)元/h起"
        if model.chargePrice != ""{
            price += " | 充电\(model.chargePrice)元/度"
        }
        priceLabel.text = price
        
        parkingNumArray.append((#imageLiteral(resourceName: "map_Fastcharge"),"\(model.fastChargeEmptyNo)个"))
        parkingNumArray.append((#imageLiteral(resourceName: "map_SlowCharge"), "\(model.slowChargeEmptyNo)个"))
        parkingNumArray.removeAll()
        var parkingNum = 0
        parkingNum += (model.insideEmptyNo)
        parkingNum += (model.outsideEmptyNo)
        parkingNumArray.append((#imageLiteral(resourceName: "map_Parkingspace"),"\(parkingNum)个"))
      parkingNumCollectionView.reloadData()
        
        tagArray.removeAll()
        if  model.tag != ""{
            let tagArr =  model.tag.components(separatedBy: ",")
            for (index,tag) in tagArr.enumerated(){
                
                if index == 0{
                    tagArray.append((UIColor.blue,tag))
                }else if index == 1{
                    tagArray.append((UIColor.green,tag))
                }else if index == 2{
                    tagArray.append((UIColor.red,tag))
                }else{
                    tagArray.append((UIColor.orange,tag))
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == tagCollectionView{
            return tagArray.count
        }
        return parkingNumArray.count
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == parkingNumCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeTagCollectionViewCell", for: indexPath) as! HomeTagCollectionViewCell
            let model = parkingNumArray[indexPath.row]
            cell.showData(model: model)
            return cell
            
        }else{//标签cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
          let label = UILabel.init(frame: cell.bounds)
            let model = tagArray[indexPath.row]
            label.text = model.title
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 11)
            label.textColor = model.color
            
            label.layer.cornerRadius = 4
            label.layer.masksToBounds = true
            label.layer.borderWidth = 1/UIScreen.main.scale
            label.layer.borderColor = model.color.cgColor
            
            cell.contentView.addSubview(label)
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 60, height: 25)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
