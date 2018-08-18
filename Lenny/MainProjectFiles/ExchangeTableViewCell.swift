//
//  ExchangeTableViewCell.swift
//  ToolGather
//
//  Created by Lenny's Macbook Pro on 2018/8/10.
//  Copyright © 2018年 Lenny. All rights reserved.
//

import UIKit
import SkeletonView


class ExchangeTableViewCell: UITableViewCell, UITextFieldDelegate {

    var data:[String]? {
        didSet {
            setValue(value: data)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private let imageView_National = UIImageView()
    private let label_Currency = UILabel()
    private let imageView_Calcu = UIImageView()
    private let textField   = UITextField()
    private let label_Bottom = UILabel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.cc_BackgroundLightBlack()
        isSkeletonable = true
        contentView.isSkeletonable = true
        contentView.addSubview(imageView_National)
        imageView_National.isSkeletonable = true
        imageView_National.whc_Top(15).whc_Bottom(15).whc_WidthAuto().whc_HeightAuto().whc_Left(15).whc_CenterY(0)
        contentView.addSubview(label_Currency)
        label_Currency.isSkeletonable = true
        label_Currency.adjustsFontSizeToFitWidth = true
        label_Currency.whc_CenterY(0).whc_Left(20, toView: imageView_National).whc_WidthAuto().whc_Height(30)
        label_Currency.textColor = UIColor.cc_Blue()
        label_Currency.font = UIFont.systemFont(ofSize: 25)
        contentView.addSubview(imageView_Calcu)
        imageView_Calcu.isSkeletonable  = true
        imageView_Calcu.whc_CenterY(0).whc_Left(15, toView: label_Currency).whc_WidthAuto().whc_HeightAuto()
        contentView.addSubview(textField)
        textField.whc_CenterY(0).whc_Right(20).whc_Width(150).whc_Height(30)
        textField.isSkeletonable = true
        textField.adjustsFontSizeToFitWidth = true
        textField.font = UIFont.systemFont(ofSize: 25)
        textField.textAlignment = .right
        textField.textColor = UIColor.cc_Blue()
        textField.returnKeyType = .done
        textField.keyboardType = .decimalPad
        textField.delegate = self
        textField.isEnabled = false
        textField.attributedPlaceholder = NSAttributedString.init(string: "0.00", attributes: [NSAttributedStringKey.foregroundColor : UIColor.cc_Blue()])
        contentView.addSubview(label_Bottom)
        label_Bottom.isSkeletonable = true
        label_Bottom.whc_RightEqual(textField).whc_Top(5, toView: textField).whc_WidthAuto().whc_Height(20)
        label_Bottom.font = UIFont.systemFont(ofSize: 15)
        label_Bottom.textColor = UIColor.gray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let f = Float(textField.text! + string) {
            print(f)
//            textField.text = String(f)
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "Exchange"), object: ["currency": currency, "exchangerate": ""])
            return validateNumber(value: string)
        }
        return false
    }
    private func validateNumber(value: String) -> Bool {
        
        var res = true
        let tmpSet = CharacterSet.init(charactersIn: "0123456789")
        var i: Int = 0
        while i < value.count {
            let s = (value as NSString).substring(with: NSRange.init(location: i, length: 1))
            if let range = s.rangeOfCharacter(from: tmpSet) {
                if range.isEmpty {
                    res = false
                    break
                }
            }
            i = i + 1
        }
        return res
    }
//    - (BOOL)validateNumber:(NSString*)number {
//    BOOL res = YES;
//    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
//    int i = 0;
//    while (i < number.length) {
//    NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
//    NSRange range = [string rangeOfCharacterFromSet:tmpSet];
//    if (range.length == 0) {
//    res = NO;
//    break;
//    }
//    i++;
//    }
//    return res;
//    }
    
    private var currency: String = ""
    func setValue(value: String) {
        
        currency = value
        if value == "CNY" {
            imageView_National.image = UIImage(named: "China_icon")
            label_Currency.text = value
            imageView_Calcu.image = UIImage(named: "Calculator_icon")
            label_Bottom.text = "人民币"
            textField.text = "100"
            textField.isEnabled = false
        }
//        if value == "USD" {
//            imageView_National.image = UIImage(named: "Dollar_icon")
//            label_Currency.text = value
//            imageView_Calcu.image = UIImage(named: "Calculator_icon")
//            label_Bottom.text = "美元"
//        }
//
//        if value == "EUR" {
//            imageView_National.image = UIImage(named: value)
//            label_Currency.text = value
//            imageView_Calcu.image = UIImage(named: "Calculator_icon")
//            label_Bottom.text = "欧元"
//        }
//
//        if value == "GBP" {
//            imageView_National.image = UIImage(named: value)
//            label_Currency.text = value
//            imageView_Calcu.image = UIImage(named: "Calculator_icon")
//            label_Bottom.text = "英镑"
//        }
//
//        if value == "JPY" {
//            imageView_National.image = UIImage(named: value)
//            label_Currency.text = value
//            imageView_Calcu.image = UIImage(named: "Calculator_icon")
//            label_Bottom.text = "日元"
//        }
//
//        if value == "HKD" {
//            imageView_National.image = UIImage(named: value)
//            label_Currency.text = value
//            imageView_Calcu.image = UIImage(named: "Calculator_icon")
//            label_Bottom.text = "港币"
//        }
    }
    
    private func setValue(value: [String]?) {
        
        if let value = value {
            
            label_Bottom.text = value.first
            textField.text = value[3]
            imageView_Calcu.image = UIImage(named: "Calculator_icon")
            
            if value.first == "澳大利亚元" {
                imageView_National.image = UIImage(named: "Australia")
                label_Currency.text = "AUD"
                currency = "AUD"
            }
            if value.first == "澳门元" {
                imageView_National.image = UIImage(named: "Macao")
                label_Currency.text = "MOP"
                currency = "MOP"
            }
            if value.first == "韩元" {
                imageView_National.image = UIImage(named: "Korea")
                label_Currency.text = "KER"
                currency = "KER"
            }
            if value.first == "加拿大元" {
                imageView_National.image = UIImage(named: "Canada")
                label_Currency.text = "CAD"
                currency = "CAD"
            }
            if value.first == "美元" {
                imageView_National.image = UIImage(named: "Dollar_icon")
                label_Currency.text = "USD"
                currency = "USD"
            }
            if value.first == "欧元" {
                imageView_National.image = UIImage(named: "EUR")
                label_Currency.text = "EUR"
                currency = "EUR"
            }
            if value.first == "日元" {
                imageView_National.image = UIImage(named: "JPY")
                label_Currency.text = "JPY"
                currency = "JPY"
            }
            if value.first == "英镑" {
                imageView_National.image = UIImage(named: "GBP")
                label_Currency.text = "GBP"
                currency = "GBP"
            }
            if value.first == "港币" {
                imageView_National.image = UIImage(named: "HKD")
                label_Currency.text = "HKD"
                currency = "HKD"
            }
        }
    }
}
