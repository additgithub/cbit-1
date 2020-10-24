import Foundation
import UIKit

struct SloatData {
    var startValue = String()
    var endValue = String()
    var displayValue = String()
    
}
struct AnswerRangeData {
    var minValue = Int()
    var maxValue = Int()
    var displayValue = String()
}
class PrivateContest {
    
    
    static let arrMaxWinner: [String] = [
        "10",
        "20",
        "30",
        "40",
        "50",
        "60"
    ]
    static let arrOfTickets: [String] = [
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8"
    ]
    static let arrOfSlots: [String] = [
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "10"
    ]
    static let arrBracketSize: [String] = [
        "80",
        "60",
        "40",
        "20",
        "10"
    ]
    static let arrBracketSizeFor1: [String] = [
        "8",
        "5",
        "3",
        "2"
    ]
    static let arrBracketSizeFor2: [String] = [
        "4",
        "3",
        "2"
    ]
    
    static let arrRangeData: [AnswerRangeData] = [
        AnswerRangeData.init(minValue: -100, maxValue: 100, displayValue: "-100 to 100"),
        AnswerRangeData.init(minValue: -10, maxValue: 10, displayValue: "-10 to 10"),
        AnswerRangeData.init(minValue: 0, maxValue: 9, displayValue: "0 to 9")
    ]
    
    //MARK: - FOR -100 to 100
    static let arr2Sloats: [SloatData] = [
        SloatData.init(startValue: "-100", endValue: "0", displayValue: "-100 to 0"),
        SloatData.init(startValue: "1", endValue: "100", displayValue: "1 to 100")
    ]
    static let arr3Sloats: [SloatData] = [
        SloatData.init(startValue: "-100", endValue: "-34", displayValue: "-100 to -34"),
        SloatData.init(startValue: "-33", endValue: "32", displayValue: "-33 to 32"),
        SloatData.init(startValue: "33", endValue: "100", displayValue: "33 to 100")
    ]
    static let arr4Sloats: [SloatData] = [
        SloatData.init(startValue: "-100", endValue: "-50", displayValue: "-100 to -50"),
        SloatData.init(startValue: "-49", endValue: "0", displayValue: "-49 to 0"),
        SloatData.init(startValue: "1", endValue: "50", displayValue: "1 to 50"),
        SloatData.init(startValue: "51", endValue: "100", displayValue: "51 to 100")
    ]
    static let arr5Sloats: [SloatData] = [
        SloatData.init(startValue: "-100", endValue: "-60", displayValue: "-100 to -60"),
        SloatData.init(startValue: "-59", endValue: "-20", displayValue: "-59 to -20"),
        SloatData.init(startValue: "-19", endValue: "20", displayValue: "-19 to 20"),
        SloatData.init(startValue: "21", endValue: "60", displayValue: "21 to 60"),
        SloatData.init(startValue: "61", endValue: "100", displayValue: "61 to 100")
    ]
    static let arr6Sloats: [SloatData] = [
        SloatData.init(startValue: "-100", endValue: "-67", displayValue: "-100 to -67"),
        SloatData.init(startValue: "-66", endValue: "-34", displayValue: "-66 to -34"),
        SloatData.init(startValue: "-33", endValue: "-1", displayValue: "-33 to -1"),
        SloatData.init(startValue: "0", endValue: "32", displayValue: "0 to 32"),
        SloatData.init(startValue: "33", endValue: "65", displayValue: "33 to 65"),
        SloatData.init(startValue: "66", endValue: "100", displayValue: "66 to 100")
    ]
    static let arr7Sloats: [SloatData] = [
        SloatData.init(startValue: "-100", endValue: "-72", displayValue: "-100 to -72"),
        SloatData.init(startValue: "-71", endValue: "-44", displayValue: "-71 to -44"),
        SloatData.init(startValue: "-43", endValue: "-16", displayValue: "-43 to -16"),
        SloatData.init(startValue: "-15", endValue: "12", displayValue: "-15 to 12"),
        SloatData.init(startValue: "13", endValue: "40", displayValue: "13 to 40"),
        SloatData.init(startValue: "41", endValue: "68", displayValue: "41 to 68"),
        SloatData.init(startValue: "69", endValue: "100", displayValue: "69 to 100")
    ]
    static let arr8Sloats: [SloatData] = [
        SloatData.init(startValue: "-100", endValue: "-75", displayValue: "-100 to -75"),
        SloatData.init(startValue: "-74", endValue: "-50", displayValue: "-74 to -50"),
        SloatData.init(startValue: "-49", endValue: "-25", displayValue: "-49 to -25"),
        SloatData.init(startValue: "-24", endValue: "0", displayValue: "-24 to 0"),
        SloatData.init(startValue: "1", endValue: "25", displayValue: "1 to 25"),
        SloatData.init(startValue: "26", endValue: "50", displayValue: "26 to 50"),
        SloatData.init(startValue: "51", endValue: "75", displayValue: "51 to 75"),
        SloatData.init(startValue: "76", endValue: "100", displayValue: "76 to 100")
    ]
    static let arr9Sloats: [SloatData] = [
        SloatData.init(startValue: "-100", endValue: "-78", displayValue: "-100 to -78"),
        SloatData.init(startValue: "-77", endValue: "-56", displayValue: "-77 to -56"),
        SloatData.init(startValue: "-55", endValue: "-34", displayValue: "-55 to -34"),
        SloatData.init(startValue: "-33", endValue: "-12", displayValue: "-33 to -12"),
        SloatData.init(startValue: "-11", endValue: "10", displayValue: "-11 to 10"),
        SloatData.init(startValue: "11", endValue: "32", displayValue: "11 to 32"),
        SloatData.init(startValue: "33", endValue: "54", displayValue: "33 to 54"),
        SloatData.init(startValue: "55", endValue: "76", displayValue: "55 to 76"),
        SloatData.init(startValue: "77", endValue: "100", displayValue: "77 to 100")
    ]
    static let arr10Sloats: [SloatData] = [
        SloatData.init(startValue: "-100", endValue: "-80", displayValue: "-100 to -80"),
        SloatData.init(startValue: "-79", endValue: "-60", displayValue: "-79 to -60"),
        SloatData.init(startValue: "-59", endValue: "-40", displayValue: "-59 to -40"),
        SloatData.init(startValue: "-39", endValue: "-20", displayValue: "-39 to -20"),
        SloatData.init(startValue: "-19", endValue: "0", displayValue: "-19 to 0"),
        SloatData.init(startValue: "1", endValue: "20", displayValue: "1 to 20"),
        SloatData.init(startValue: "21", endValue: "40", displayValue: "21 to 40"),
        SloatData.init(startValue: "41", endValue: "60", displayValue: "41 to 60"),
        SloatData.init(startValue: "61", endValue: "80", displayValue: "61 to 80"),
        SloatData.init(startValue: "81", endValue: "100", displayValue: "81 to 100")
    ]
    
    
    //MARK: - FOR -10 to 10

    static let arr2SloatsFor1: [SloatData] = [
        SloatData.init(startValue: "-10", endValue: "0", displayValue: "-10 to 0"),
        SloatData.init(startValue: "1", endValue: "10", displayValue: "1 to 10")
    ]
    static let arr3SloatsFor1: [SloatData] = [
        SloatData.init(startValue: "-10", endValue: "-4", displayValue: "-10 to -4"),
        SloatData.init(startValue: "-3", endValue: "2", displayValue: "-3 to 2"),
        SloatData.init(startValue: "3", endValue: "10", displayValue: "3 to 10")
    ]
    static let arr4SloatsFor1: [SloatData] = [
        SloatData.init(startValue: "-10", endValue: "-5", displayValue: "-10 to -5"),
        SloatData.init(startValue: "-4", endValue: "0", displayValue: "-4 to 0"),
        SloatData.init(startValue: "1", endValue: "5", displayValue: "1 to 5"),
        SloatData.init(startValue: "6", endValue: "10", displayValue: "6 to 10")
    ]
    static let arr5SloatsFor1: [SloatData] = [
        SloatData.init(startValue: "-10", endValue: "-6", displayValue: "-10 to -6"),
        SloatData.init(startValue: "-5", endValue: "-2", displayValue: "-5 to -2"),
        SloatData.init(startValue: "-1", endValue: "2", displayValue: "-1 to 2"),
        SloatData.init(startValue: "3", endValue: "6", displayValue: "3 to 6"),
        SloatData.init(startValue: "7", endValue: "10", displayValue: "7 to 10")
    ]
    static let arr6SloatsFor1: [SloatData] = [
        SloatData.init(startValue: "-10", endValue: "-7", displayValue: "-10 to -7"),
        SloatData.init(startValue: "-6", endValue: "-4", displayValue: "-6 to -4"),
        SloatData.init(startValue: "-3", endValue: "-1", displayValue: "-3 to -1"),
        SloatData.init(startValue: "0", endValue: "2", displayValue: "0 to 2"),
        SloatData.init(startValue: "3", endValue: "5", displayValue: "3 to 5"),
        SloatData.init(startValue: "6", endValue: "10", displayValue: "6 to 10")
    ]
    static let arr7SloatsFor1: [SloatData] = [
        SloatData.init(startValue: "-10", endValue: "-8", displayValue: "-10 to -8"),
        SloatData.init(startValue: "-7", endValue: "-4", displayValue: "-7 to -4"),
        SloatData.init(startValue: "-3", endValue: "-1", displayValue: "-3 to -1"),
        SloatData.init(startValue: "0", endValue: "0", displayValue: "0"),
        SloatData.init(startValue: "1", endValue: "3", displayValue: "-1 to 3"),
        SloatData.init(startValue: "4", endValue: "7", displayValue: "4 to 7"),
        SloatData.init(startValue: "8", endValue: "10", displayValue: "8 to 10")
    ]
    static let arr8SloatsFor1: [SloatData] = [
        SloatData.init(startValue: "-10", endValue: "-8", displayValue: "-10 to -8"),
        SloatData.init(startValue: "-7", endValue: "-6", displayValue: "-7 to -6"),
        SloatData.init(startValue: "-5", endValue: "-4", displayValue: "-5 to -4"),
        SloatData.init(startValue: "-3", endValue: "-2", displayValue: "-3 to -2"),
        SloatData.init(startValue: "-1", endValue: "0", displayValue: "-1 to 0"),
        SloatData.init(startValue: "1", endValue: "2", displayValue: "1 to 2"),
        SloatData.init(startValue: "3", endValue: "4", displayValue: "3 to 4"),
        SloatData.init(startValue: "5", endValue: "10", displayValue: "5 to 10")
    ]
    //9 (-10 to -8 , -7 to -6 , -5 to -4 ,-3 to -2 ,-1 to 0 ,1 to 2 ,3 to 4 ,5 to 6 ,7 to 10 )
    static let arr9SloatsFor1: [SloatData] = [
        SloatData.init(startValue: "-10", endValue: "-8", displayValue: "-10 to -8"),
        SloatData.init(startValue: "-7", endValue: "-6", displayValue: "-7 to -6"),
        SloatData.init(startValue: "-5", endValue: "-4", displayValue: "-5 to -4"),
        SloatData.init(startValue: "-3", endValue: "-2", displayValue: "-3 to -2"),
        SloatData.init(startValue: "-1", endValue: "0", displayValue: "-1 to 0"),
        SloatData.init(startValue: "1", endValue: "2", displayValue: "1 to 2"),
        SloatData.init(startValue: "3", endValue: "4", displayValue: "3 to 4"),
        SloatData.init(startValue: "5", endValue: "6", displayValue: "5 to 6"),
        SloatData.init(startValue: "7", endValue: "10", displayValue: "7 to 10")
    ]
    static let arr10SloatsFor1: [SloatData] = [
        SloatData.init(startValue: "-10", endValue: "-8", displayValue: "-10 to -8"),
        SloatData.init(startValue: "-7", endValue: "-6", displayValue: "-7 to -6"),
        SloatData.init(startValue: "-5", endValue: "-4", displayValue: "-5 to -4"),
        SloatData.init(startValue: "-3", endValue: "-2", displayValue: "-3 to -2"),
        SloatData.init(startValue: "-1", endValue: "0", displayValue: "-1 to 0"),
        SloatData.init(startValue: "1", endValue: "2", displayValue: "1 to 2"),
        SloatData.init(startValue: "3", endValue: "4", displayValue: "3 to 4"),
        SloatData.init(startValue: "5", endValue: "6", displayValue: "5 to 6"),
        SloatData.init(startValue: "7", endValue: "8", displayValue: "7 to 8"),
        SloatData.init(startValue: "9", endValue: "10", displayValue: "9 to 10")
    ]
    
    //MARK: - FOR 0 to 9
    static let arr2SloatsFor2: [SloatData] = [
        SloatData.init(startValue: "0", endValue: "4", displayValue: "0 to 4"),
        SloatData.init(startValue: "5", endValue: "9", displayValue: "5 to 9")
    ]
    static let arr3SloatsFor2: [SloatData] = [
        SloatData.init(startValue: "0", endValue: "3", displayValue: "0 to 3"),
        SloatData.init(startValue: "4", endValue: "6", displayValue: "4 to 6"),
        SloatData.init(startValue: "7", endValue: "9", displayValue: "7 to 9")
    ]
    static let arr4SloatsFor2: [SloatData] = [
        SloatData.init(startValue: "0", endValue: "2", displayValue: "0 to 2"),
        SloatData.init(startValue: "3", endValue: "4", displayValue: "3 to 4"),
        SloatData.init(startValue: "5", endValue: "6", displayValue: "5 to 6"),
        SloatData.init(startValue: "7", endValue: "9", displayValue: "7 to 9")
    ]
    static let arr5SloatsFor2: [SloatData] = [
        SloatData.init(startValue: "0", endValue: "1", displayValue: "0 to 1"),
        SloatData.init(startValue: "2", endValue: "2", displayValue: "2"),
        SloatData.init(startValue: "3", endValue: "3", displayValue: "3"),
        SloatData.init(startValue: "4", endValue: "4", displayValue: "4"),
        SloatData.init(startValue: "5", endValue: "9", displayValue: "5 to 9")
    ]
    static let arr6SloatsFor2: [SloatData] = [
        SloatData.init(startValue: "0", endValue: "1", displayValue: "0 to 1"),
        SloatData.init(startValue: "2", endValue: "2", displayValue: "2"),
        SloatData.init(startValue: "3", endValue: "3", displayValue: "3"),
        SloatData.init(startValue: "4", endValue: "4", displayValue: "4"),
        SloatData.init(startValue: "5", endValue: "5", displayValue: "5"),
        SloatData.init(startValue: "6", endValue: "9", displayValue: "6 to 9")
    ]
    static let arr7SloatsFor2: [SloatData] = [
        SloatData.init(startValue: "0", endValue: "1", displayValue: "0 to 1"),
        SloatData.init(startValue: "2", endValue: "2", displayValue: "2"),
        SloatData.init(startValue: "3", endValue: "3", displayValue: "3"),
        SloatData.init(startValue: "4", endValue: "4", displayValue: "4"),
        SloatData.init(startValue: "5", endValue: "5", displayValue: "5"),
        SloatData.init(startValue: "6", endValue: "6", displayValue: "6"),
        SloatData.init(startValue: "7", endValue: "9", displayValue: "7 to 9")
    ]
    static let arr8SloatsFor2: [SloatData] = [
        SloatData.init(startValue: "0", endValue: "1", displayValue: "0 to 1"),
        SloatData.init(startValue: "2", endValue: "2", displayValue: "2"),
        SloatData.init(startValue: "3", endValue: "3", displayValue: "3"),
        SloatData.init(startValue: "4", endValue: "4", displayValue: "4"),
        SloatData.init(startValue: "5", endValue: "5", displayValue: "5"),
        SloatData.init(startValue: "6", endValue: "6", displayValue: "6"),
        SloatData.init(startValue: "7", endValue: "7", displayValue: "7"),
        SloatData.init(startValue: "8", endValue: "9", displayValue: "8 to 9")
    ]
    static let arr9SloatsFor2: [SloatData] = [
        SloatData.init(startValue: "0", endValue: "1", displayValue: "0 to 1"),
        SloatData.init(startValue: "2", endValue: "2", displayValue: "2"),
        SloatData.init(startValue: "3", endValue: "3", displayValue: "3"),
        SloatData.init(startValue: "4", endValue: "4", displayValue: "4"),
        SloatData.init(startValue: "5", endValue: "5", displayValue: "5"),
        SloatData.init(startValue: "6", endValue: "6", displayValue: "6"),
        SloatData.init(startValue: "7", endValue: "7", displayValue: "7"),
        SloatData.init(startValue: "8", endValue: "8", displayValue: "8"),
        SloatData.init(startValue: "9", endValue: "9", displayValue: "9")
    ]
    static let arr10SloatsFor2: [SloatData] = [
        SloatData.init(startValue: "0", endValue: "0", displayValue: "0"),
        SloatData.init(startValue: "1", endValue: "1", displayValue: "1"),
        SloatData.init(startValue: "2", endValue: "2", displayValue: "2"),
        SloatData.init(startValue: "3", endValue: "3", displayValue: "3"),
        SloatData.init(startValue: "4", endValue: "4", displayValue: "4"),
        SloatData.init(startValue: "5", endValue: "5", displayValue: "5"),
        SloatData.init(startValue: "6", endValue: "6", displayValue: "6"),
        SloatData.init(startValue: "7", endValue: "7", displayValue: "7"),
        SloatData.init(startValue: "8", endValue: "8", displayValue: "8"),
        SloatData.init(startValue: "9", endValue: "9", displayValue: "9")
    ]
}
