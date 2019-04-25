
import UIKit

extension UIColorExtras {

    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
    
    var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0.0
        var s: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h, s, b, a)
    }
    
    func replacingHue(with newValue: CGFloat) -> UIColor {
        let current = hsba
        return UIColor(hue: newValue, saturation: current.saturation, brightness: current.brightness, alpha: current.alpha)
    }
    func replacingSaturation(with newValue: CGFloat) -> UIColor {
        let current = hsba
        return UIColor(hue: current.hue, saturation: newValue, brightness: current.brightness, alpha: current.alpha)
    }
    func replacingBrightness(with newValue: CGFloat) -> UIColor {
        let current = hsba
        return UIColor(hue: current.hue, saturation: current.saturation, brightness: newValue, alpha: current.alpha)
    }
    
    func replacingRed(with newValue: CGFloat) -> UIColor {
        let current = rgba
        return UIColor(red: newValue, green: current.green, blue: current.blue, alpha: current.alpha)
    }
    func replacingGreen(with newValue: CGFloat) -> UIColor {
        let current = rgba
        return UIColor(red: current.red, green: newValue, blue: current.blue, alpha: current.alpha)
    }
    func replacingBlue(with newValue: CGFloat) -> UIColor {
        let current = rgba
        return UIColor(red: current.red, green: current.green, blue: newValue, alpha: current.alpha)
    }
    
    func replacingAlpha(with newValue: CGFloat) -> UIColor {
        let current = rgba
        return UIColor(red: current.red, green: current.green, blue: current.blue, alpha: newValue)
    }
    
    static func fromHex(_ hexString: String?) -> UIColor? {
        guard let hexString = hexString else { return nil }
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 7:
            chars = ["0"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    var hexString: String {
        let components = self.rgba
        let rgba: Int = Int(components.alpha*255.0)<<24 | Int(components.red*255.0)<<16 | Int(components.green*255)<<8 | Int(components.blue*255)<<0
        return String(format:"#%06x", rgba)
    }
    
}
