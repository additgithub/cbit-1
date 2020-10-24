import Foundation
import UIKit

struct Tickets {
    var value = Int()
    var isSelected = Bool()
    init(value: Int, isSelected: Bool = false) {
        self.value = value
        self.isSelected = isSelected
    }
    
}

struct BracketData {
    var color = UIColor()
    var index = Int()
}

class MyDataType {
    var arrColors = [UIColor]()
    var arrColorlevel1 = [UIColor]()
    var arrColorlevel2 = [UIColor]()
    var arrColorlevel3 = [UIColor]()
    var arrBracketData = [BracketData]()
    
    init() {
        setColor()
        setBackets()
    }
    
    func setColor() {
        arrColors = [
            #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1),
            #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),
            #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),
            #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),
            #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1),
            #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),
            #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),
            #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),
            #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1),
            #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),
        ]
    }
    
    func setBackets() {
        arrBracketData = [
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 0),
            BracketData.init(color: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), index: 1),
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 2),
            BracketData.init(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), index: 3),
            
            BracketData.init(color: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), index: 4),
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 5),
            BracketData.init(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), index: 6),
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 7),
            
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 8),
            BracketData.init(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), index: 9),
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 10),
            BracketData.init(color: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), index: 11),
            
            BracketData.init(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), index: 12),
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 13),
            BracketData.init(color: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), index: 14),
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 15),
            
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 16),
            BracketData.init(color: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), index: 17),
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 18),
            BracketData.init(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), index: 19),
            
            BracketData.init(color: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), index: 20),
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 21),
            BracketData.init(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), index: 22),
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 23),
            
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 24),
            BracketData.init(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), index: 25),
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 26),
            BracketData.init(color: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), index: 27),
            
            BracketData.init(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), index: 28),
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 29),
            BracketData.init(color: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), index: 30),
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 31),
            
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 32),
            BracketData.init(color: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), index: 33),
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 34),
            BracketData.init(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), index: 35),
            
            BracketData.init(color: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), index: 36),
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 37),
            BracketData.init(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), index: 38),
            BracketData.init(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), index: 39),
        ]
    }
    
    
    func getArrColor(index: Int) -> [UIColor] {
        var arrSelectedColor = [UIColor]()
        
        for (colorIndex,item) in arrColors.enumerated() {
            if colorIndex == index {
                break
            }
            arrSelectedColor.append(item)
        }
        return arrSelectedColor
    }
    
    func getArrayBrackets(index: Int) -> [BracketData] {
        var arrSelectedBrackets = [BracketData]()
        
        for (bracketIndex, item) in arrBracketData.enumerated() {
            if bracketIndex == index {
                break
            }
            arrSelectedBrackets.append(item)
        }
        return arrSelectedBrackets
    }
}
