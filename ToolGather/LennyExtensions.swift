//
//  LennyExtensions.swift
//  Test
//
//  Created by Lenny's iMac on 05/10/2019.
//

extension UIDevice{
    class var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    class var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
}


extension NSData{
    
    private var desKey:String {
        return "12345678";
    }
    //MARK: - DES加密和解密
    private func desOperation(operation:CCOperation)->NSData?{
        let keyData: NSData! = self.desKey.data(using: String.Encoding.utf8, allowLossyConversion: false)! as NSData?
        let keyBytes = UnsafeRawPointer(keyData.bytes);
        let keyLength        = size_t(kCCKeySizeDES)
        let dataLength       = Int(self.length)
        let dataBytes        = UnsafeRawPointer(self.bytes)
        let bufferData       = NSMutableData(length: Int(dataLength) + kCCBlockSizeDES)!
        let bufferPointer    = UnsafeMutableRawPointer(bufferData.mutableBytes)
        let bufferLength     = size_t(bufferData.length)
        var bytesDecrypted   = Int(0)
        
        let cryptStatus = CCCrypt(operation, CCAlgorithm(kCCAlgorithmDES),
                                  CCOptions(kCCOptionPKCS7Padding) | CCOptions(kCCOptionECBMode),
                                  keyBytes,
                                  keyLength,
                                  nil,
                                  dataBytes,
                                  dataLength,
                                  bufferPointer,
                                  bufferLength,
                                  &bytesDecrypted);
        if Int32(cryptStatus) == Int32(kCCSuccess) {
            bufferData.length = bytesDecrypted;
            return bufferData as NSData;
        }else {
            print("Error in crypto operation: \(cryptStatus)")
            return nil;
        }
    }
    //MARK: - DES加密
    public func desEncrypt()->NSData?{
        return self.desOperation(operation: CCOperation(kCCEncrypt));
    }
    
    //MARK: - DES解密
    public func desDecrypt()->NSData?{
        return self.desOperation(operation: CCOperation(kCCDecrypt));
    }
    
    //MARK: - base64加密
    public func base64EncodedString()->String{
        return self.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue:0));
    }

    //MARK: - base64解密
    public static func base64Decode(string:String)->NSData?{
        return NSData(base64Encoded: string, options: NSData.Base64DecodingOptions(rawValue:0));
    }
}

extension String{
    
    var md5String: String? {
        let str = self.cString(using: String.Encoding.utf8);
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8));
        let digestLen = Int(CC_MD5_DIGEST_LENGTH);
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen);
        CC_MD5(str!, strLen, result);
        let hash = NSMutableString();
        for i in 0..<digestLen {
            hash.appendFormat("%02X", result[i]);//大写
        }
        result.deinitialize(count: 0)
        return String(format: hash as String);
    }
    
    // 汉字范围 \u4e00-\u9fa5 (中文)
    var containChinese: Bool {
        do {
            let pattern = "[\\u4e00-\\u9fa5]";
            let regx = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive);
            let rs = regx.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue:0), range: NSMakeRange(0, self.count));
            if rs.count > 0 {
                return true;
            }else {
                return false;
            }
        }catch {
            return false;
        }
    }
    
    func chineseToUnicode() -> String? {
        if self.containChinese == true {
            let length = self.count;
            let s: NSString = self as NSString;
            let result: NSMutableString = NSMutableString();
            for i in 0 ..< length {
                let _char: UInt32 = UInt32(s.character(at: i));
                // 汉字范围 \u4e00-\u9fa5 (中文)
                if (_char >= 19968 && _char <= 171941) {
                    result.appendFormat("\\u%x", _char);//16进制
                }else{
                    result.appendFormat("%c", _char);
                }
            }
            return result as String;
        }else{
            return self;
        }
    }
    
    /**
     *  转换为Base64编码
     */
    func base64EncodedString() -> String? {
        return self.data(using: String.Encoding.utf8)?.base64EncodedString()
    }
    
    /**
     *  将Base64编码还原
     */
    public func base64DecodedString() -> String? {
        if let data = Data.init(base64Encoded: self , options: Data.Base64DecodingOptions(rawValue: 0)) {
            return String.init(data: data, encoding: String.Encoding.utf8)
        }else {
            return nil
        }
    }
    
    //MARK: - 验证是否是数字
    var isNum: Bool {
        let numRegex = "^[0-9]{1,2}"
        let numPredicate = NSPredicate(format: "SELF MATCHES %@", numRegex)
        let num = numPredicate.evaluate(with: self)
        return num
    }
    
   //MARK: - 验证用户名
    var validateUserName: Bool {
    let userNameRegex = "^[a-z]\\w{4,9}"
    let userNamePredicate = NSPredicate(format: "SELF MATCHES %@", userNameRegex)
    let peopleName = userNamePredicate.evaluate(with: self)
    return peopleName
    }
    
    /// 验证用户名
    var validUsername: Bool {
        let userNameRegex = "^[a-z]\\w{4,9}"
        let userNamePredicate = NSPredicate(format: "SELF MATCHES %@", userNameRegex)
        return userNamePredicate.evaluate(with: self)
    }
    /// 验证是否存在英文或者数字 http://blog.devtao.com/2016/06/22/iOS-UnicodeScalars/
    var isHasNumOrCharacter: Bool {
        
        for commichar in self.unicodeScalars {
            // 字符为大写英文字母 ， 字符为小写英文字母 ， 字符为数字  ,只要包含一个英文、数字 都返回false 否则返回true
            if (commichar.value>64&&commichar.value<91) || (commichar.value>96&&commichar.value<123) || (commichar.value>47&&commichar.value<58){
                return false
            }
        }
        return true
    }
    
    //MARK: - 验证密码
    var validatePassword: Bool {
        let passWordRegex = "^[a-zA-Z0-9]{6,15}+$"
        let passWordPredicate = NSPredicate(format: "SELF MATCHES%@", passWordRegex)
        return passWordPredicate.evaluate(with: self)
    }
    
    //MARK: - 验证推广码
    var validateSpreadCode: Bool {
        let codeRegex = "^[a-zA-Z0-9]{3,10}+$"
        let codePredicate = NSPredicate(format: "SELF MATCHES%@", codeRegex)
        return codePredicate.evaluate(with:self)
    }
    
    //MARK: - 整数或者小数
    var validateFloatOrInteger: Bool {
        let passWordRegex = "^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$"
        let passWordPredicate = NSPredicate(format: "SELF MATCHES%@", passWordRegex)
        return passWordPredicate.evaluate(with: self)
    }
    
    //MARK: -  验证是否是银行卡号格式
    var validateBankCardNumber: Bool {
        let regex = "^(\\d{16}|\\d{19})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:self)
    }
    
    //MARK: - 验证是否是一定范围的数字格式
    var validateLimitNumber: Bool {
        let regex = "^\\d{16,19}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:self)
    }
    
    //MARK: - 验证是否是信用卡号格式(VISA卡，万事达卡，Discover卡，美国运通卡)
    var validateCreditCard: Bool {
        let regex = "((?:4\\d{3})|(?:5[1-5]\\d{2})|(?:6011)|(?:3[68]\\d{2})|(?:30[012345]\\d))[ -]?(\\d{4})[ -]?(\\d{4})[ -]?(\\d{4}|3[4,7]\\d{13})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:self)
    }
    
    //MARK: - 验证是否是身份证号格式
    var validateIdCard: Bool {
        let regex = "^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:self)
    }
    
    //MARK: - 验证是否是电子邮箱格式
    var validateEmailFormat: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:self)
    }
    
    //MARK: - 验证是否是手机号码格式
    var validateMobileNumber: Bool {
        let regex = "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:self)
    }
    
    //MARK: - 验证金额的方法如下 ，提现金额不得超过小数点后两位
    var validateAmount: Bool {
        let regex = "^[0-9]+(\\.[0-9]{1,4})?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:self)
    }
 
    //MARK: -t验证是否有效的微信号
    var validateWeiXinAccount: Bool {
        let regex = "^[a-zA-Z]{1}[-_a-zA-Z0-9]{5,19}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:self)
    }
    
    //MARK: 验证是否为有效的QQ
    var validateQQAccount: Bool {
        let regex = "[1-9][0-9]{4,14}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:self)
    }
    
    func createQRCodeForString() -> UIImage?{
        //        1.创建一个滤镜
        let filter = CIFilter(name:"CIQRCodeGenerator")
        //        2.将滤镜恢复到默认状态
        filter?.setDefaults()
        //        3.为滤镜添加属性    （"函冰"即为二维码扫描出来的内容，可以根据需求进行添加）
        filter?.setValue(self.data(using: String.Encoding.utf8), forKey: "InputMessage")
        //        判断是否有图片
        guard let ciimage = filter?.outputImage else {
            return nil
        }
        //        4。将二维码赋给imageview,此时调用网上找的代码片段，由于SWift3的变化，将其稍微改动，生成清晰的二维码
        let image = createNonInterpolatedUIImageFormCIImage(image: ciimage, size: 200)
        return image
    }
    /**
     生成高清二维码
     
     - parameter image: 需要生成原始图片
     - parameter size:  生成的二维码的宽高
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        // 1.创建bitmap;
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale);
        //        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        bitmapRef.draw(bitmapImage, in: extent)
        // 2.保存bitmap到图片
        let scaledImage: CGImage = bitmapRef.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }

    /// 随机数
    func random1_100() -> String {
        return String.init(format: "%.3f", Double(Int(arc4random())%100+1) / Double(self)!)
    }
    
    /// 只能为数字
     func onlyInputTheNumber() -> Bool {
        if self.count == 0 {return false}
        let numString = "[0-9]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", numString)
        let number = predicate.evaluate(with: self)
        return number
    }
    
    /// 将数字类型转成Double ，例如：2000,00.000 -> 2000.00000 不能超过double类型的长度，否则会出现科学计数
    var doubleValue: Double {
        let inputFormatter = NumberFormatter.init()
        inputFormatter.maximumSignificantDigits = 100
        if self.contains(",") {inputFormatter.numberStyle = .decimal}else{inputFormatter.numberStyle = .none}
        let inputAmount = inputFormatter.number(from: self)
        return inputAmount?.doubleValue ?? 0.0000
    }
    
    /// 将字符串转成浮点型 Float  类型
    var floatValue: Float {
        let inputFormatter = NumberFormatter.init()
        let inputAmount = inputFormatter.number(from: self)
        return inputAmount?.floatValue ?? 0.0000
    }
    /// 将字符串转成整型 int  类型
    var intValue: Int {
        let inputFormatter = NumberFormatter.init()
        let inputAmount = inputFormatter.number(from: self)
        return inputAmount?.intValue ?? 0
    }
    /// 将字符串转成 cgfloat 类型
    var cgfloatValue: CGFloat {
        let inputFormatter = NumberFormatter.init()
        let inputAmount = inputFormatter.number(from: self)
        let cgfloat = CGFloat.init(inputAmount?.floatValue ?? 0)
        return cgfloat
    }
    
    /// 去掉字符串末尾多余的0
    var removeZeroValue: String {
        let zeroValue = String.init(format: "%@", NSNumber.init(value: self.floatValue))
        return zeroValue
    }
    
    /// 处理奖期字符串
    /// 取后三位 遇到-则取-后面的，否则取后三位
    var issueLastTime:String?
    {
        if self.contains("-")  == true{
            let ming =  self.components(separatedBy: "-")
            return ming.last
        }else{
            return String.init(self.suffix(3))
        }
    }
}

extension UIImage {
    
    /// 由颜色画出一条横线图片
    class func imageLine(color:UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: kSCREEN_WIDTH, height: 1), false, 0)
        let p = UIBezierPath.init(rect: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: 1))
        color.setFill()
        p.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image as UIImage
    }
    
    /// 由颜色画出圆图片
    class func imageArc(color:UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 80, height: 80), false, 0)
        let p = UIBezierPath.init(arcCenter: CGPoint(x: 40, y: 40), radius: 40, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: false)
        color.setFill()
        p.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image as UIImage
    }
    
    /// 圆圈⭕️
    class func imageStrokeArc(color:UIColor,lineW:CGFloat,size:CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: size.width, height: size.height), false, 0)
        let p = UIBezierPath.init(arcCenter: CGPoint(x: size.width/2.0, y: size.height/2.0), radius: size.width/2.0-0.5, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        p.lineWidth = lineW
        color.setStroke()
        p.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image as UIImage
    }
    
    
    /// 彩色图片置灰，灰度图片
    public func grayImage() -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil , width: Int(self.size.width), height: Int(self.size.height),bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        context?.draw(self.cgImage!, in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let cgImage = context!.makeImage()
        let grayImage = UIImage.init(cgImage: cgImage!)
        return grayImage
    }
    
    //保存图片至沙盒
    public func saveImage(persent: CGFloat, imageName: String) -> String? {
        if let imageData = jpegData(compressionQuality: persent) as NSData? {
//            let fullPath = NSHomeDirectory().appending("/Documents/WelcomeImage/").appending(imageName)
            var documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            documentPaths.append(imageName)
            imageData.write(toFile: documentPaths, atomically: true)
            print("fullPath=\(documentPaths)")
            return documentPaths
        }
        return nil
    }
    
}
extension UIButton {
    
    func imageTitleAlignCenter() {
        
        // 间隙
        let space:CGFloat = 15.0
        contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        // 设置title
        titleEdgeInsets = UIEdgeInsets(top: (imageView?.frame.size.height)! + space, left: -(imageView?.frame.size.width)!, bottom: 0.0, right: 0.0)
        // 设置image
        imageEdgeInsets = UIEdgeInsets(top: -space, left: 0.0, bottom: 0.0, right: -(titleLabel?.bounds.size.width)!)
    }
    /// 设置文字显示位置
    ///
    /// - Parameters:
    ///   - anImage: 图片
    ///   - title: 文字
    ///   - titlePosition: 标题交换模式
    ///   - additionalSpacing: 间隙
    ///   - state: 按钮状态
    @objc func set(image anImage: UIImage?, title: String, titlePosition: UIView.ContentMode, additionalSpacing: CGFloat, state: UIControl.State){
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)
        
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    /// 设置按钮的图片标题位置
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - position: 交换模式
    ///   - spacing: 间隙
    private func positionLabelRespectToImage(title: String, position: UIView.ContentMode, spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
    
    class func button(text: String, font: UIFont = UIFont.systemFont(ofSize: 15),textColor: UIColor = UIColor.black, textAliment: NSTextAlignment = NSTextAlignment.center, backGroundImage: UIImage? = UIImage(), setImage: UIImage? = UIImage()) -> UIButton {
        let button = UIButton.init()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.textAlignment = textAliment
        button.setBackgroundImage(backGroundImage, for: .normal)
        button.setImage(setImage, for: .normal)
        return button
    }
    class func button(text: String, font: UIFont, textColor: UIColor,backGroundImage: UIImage?) -> UIButton {
        return button(text: text, font: font, textColor: textColor, textAliment: .center, backGroundImage: backGroundImage, setImage: UIImage())
    }
    class func button(backGroundImage: UIImage?) -> UIButton {
        return button(text: "", font: .systemFont(ofSize: 10), textColor: .white, backGroundImage: backGroundImage)
    }
    
    @objc private func button_StoreAction() {
        let block = objc_getAssociatedObject(self, &button_Store_Key) as! buttonBlock
        block(self)
    }
    func setDidClicked(block: @escaping buttonBlock ) {
        objc_setAssociatedObject(self, &button_Store_Key, block, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        addTarget(self, action: #selector(button_StoreAction), for: .touchUpInside)
    }
}
typealias buttonBlock = ((UIButton) -> Void)
private var button_Store_Key = "button_Store_Key"


import AVFoundation
extension UIView {
    
    class func shakeBody(needSound:Bool = false) {
        //建立的SystemSoundID对象
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)
        //振动
        AudioServicesPlaySystemSound(soundID)
        if needSound == true {
            AudioServicesPlayAlertSound(UInt32(1007))
        }
    }
    
    func shake(needSound: Bool = false) {
        //建立的SystemSoundID对象
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)
        //振动
        AudioServicesPlaySystemSound(soundID)
        if needSound == true {
            AudioServicesPlayAlertSound(UInt32(1007))
        }
    }
}

extension UILabel {
    /**  改变行间距  */
    func changeLineSpace(space:CGFloat) {
        guard let text = self.text else {
            return
        }
        let attributedString = NSMutableAttributedString.init(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: text.count))
        self.attributedText = attributedString
        self.sizeToFit()
    }
    /**  改变字间距  */
    func changeWordSpace(space:CGFloat) {
        guard let text = self.text else {
            return
        }
        let attributedString = NSMutableAttributedString.init(string: text, attributes: [NSAttributedString.Key.kern:space])
        let paragraphStyle = NSMutableParagraphStyle()
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: text.count))
        self.attributedText = attributedString
        self.sizeToFit()
    }
    /**  改变字间距和行间距  */
    func changeSpace(lineSpace:CGFloat, wordSpace:CGFloat) {
        guard let text = self.text else {
            return
        }
        let attributedString = NSMutableAttributedString.init(string: text, attributes: [NSAttributedString.Key.kern:wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: text.count))
        self.attributedText = attributedString
        self.sizeToFit()
    }
    
    class func label(text: String, font: UIFont = UIFont.systemFont(ofSize: 12), textColor: UIColor = UIColor.black, textAliment: NSTextAlignment = NSTextAlignment.center) -> UILabel {
        let label = UILabel.init()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAliment
        return label
    }
}

extension UIViewController {
    class func current(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return current(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return current(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return current(base: presented)
        }
        return base
    }
}

extension UITextField {
    
    class func textField(font: UIFont = UIFont.systemFont(ofSize: 12), textColor: UIColor = UIColor.black, roundCorner: CGFloat? = 5, style: UITextField.BorderStyle = .none) -> UITextField {
        let textF = UITextField.init()
        textF.font = font
        textF.textColor = textColor
        textF.layer.cornerRadius = roundCorner ?? 0
        textF.borderStyle = style
        return textF
    }
    /// 键盘输入时，如果字符超过两位小数则不能再输入多余的字符，如果输入的是字母，只要有小数点，则自动取小数点后两个字母，同样也不能输入超过小数点后两个字符的字符
    /// 使用在 textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool 代理方法内
    ///
    /// - Parameter string: 单个字符
    /// - Returns: 是否是超过后两位小数
    func onlyTwoDecimal(replacementString string: String) -> Bool
    {
        return onlyAnyDecimal(number: 2, replacementString: string)
    }
    
    /// 键盘输入时，数字不超过指定的小数点后几位
    ///
    /// - Parameters:
    ///   - number: 保留后几位
    ///   - string: 字符
    /// - Returns: 是否是超过后指定小数位数
    func onlyAnyDecimal(number:Int,replacementString string: String) -> Bool
    {
        if number == 0 && string == "."
        {
            return false
        }
        
        if self.text?.contains(".") == true && string != "",let text = self.text{
            
            if let indexStart = text.firstIndex(of: "."),let indexEnd = text.index(indexStart, offsetBy: number+1, limitedBy: text.endIndex)
            {
                let string = text[indexStart..<indexEnd]
                if string.count == number+1
                {
                    return false
                }
            }
        }
        return true
    }
}


extension NSAttributedString {
    
    /// 设置拼接富文本
    ///
    /// - Parameters:
    ///   - normal: 不变颜色的文字
    ///   - value: 改变颜色的文字
    ///   - valueColor: 颜色
    /// - Returns: 富文本
    class func attrStr(normalText: String, valueText: String, valueColor: UIColor) -> NSAttributedString{
        let muStr = NSMutableAttributedString.init(string: normalText)
        let profit_loss = NSAttributedString.init(string: valueText, attributes: [NSAttributedString.Key.foregroundColor : valueColor])
        muStr.append(profit_loss)
        return muStr
    }
}

extension Array {
    /// 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}

extension Date {
    
    /// -->转换为字符串
    var string: String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        let time = formatter.string(from: self)
        return time
    }
    
    /// 获取距离当前时间多久的一个日期
    ///
    /// - Parameters:
    ///   - year: year = 1表示1年后的时间 year = -1为1年前的日期
    ///   - month: 距离现在几个月
    ///   - days: 距离现在几天
    /// - Returns: 返回一个新的日期
    static func obtainNewDateFrom(year: Int,month: Int,days: Int) -> Date {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var component = calendar?.components([NSCalendar.Unit.year,NSCalendar.Unit.month,NSCalendar.Unit.day], from: Date.init())
        component?.year = year
        component?.month = month
        component?.day = days
        let newDate = calendar?.date(byAdding: component!, to: Date.init(), options: NSCalendar.Options(rawValue: 0))
        return newDate!
    }
}


extension UITabBarController {
    
    /// 添加子控制器
    ///
    /// - Parameter StoryName: 控制器StoryName
    func addChildViewController(StoryName:String) {
        guard let vc = UIStoryboard.init(name: StoryName, bundle: nil).instantiateInitialViewController() else {
            return
        }
        super.addChild(vc)
    }
    
    /// 添加控制器
    ///
    /// - Parameter storyNames: StoryName名称数组
    func addChildViewControllers(storyNames:[String]) {
        for item in storyNames {
            addChildViewController(StoryName: item)
        }
    }
    
    
    /// 点击选中的tabbar自动让当前控制器滚动到顶部
    ///
    /// - Parameter vc: BaseNavigationController
    func scrollTotop(vc: BaseNavigationController)
    {
        
        if let vc = vc.topViewController as? BaseViewController
        {
            vc.scrollTotop()
        }
//        if let vc = vc.topViewController as? QSwitchBuyTicketPageController
//        {
//            if let vc = vc.currentViewController as? QBuyTicketViewController
//            {
//                vc.scrollTotop()
//            }
//
//        }
//        if let vc = vc.topViewController as? QLotteryPageController
//        {
//            if let vc = vc.currentViewController as? QLotteryViewController
//            {
//                vc.scrollTotop()
//            }
//        }
    }
    
}
extension NSError {
    public convenience init(domain: String, code: BuglyReportCodeType) {
        self.init(domain: domain, code: code.rawValue, userInfo: nil)
    }
    
    public enum BuglyReportCodeType:Int {
        case unknown = -00000
        case changeNetLine = -10000
        case dataError = -10001
    }
}
