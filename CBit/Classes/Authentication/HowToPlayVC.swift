import UIKit

class HowToPlayVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var labelHowToPlay: UILabel!
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setGamePlayInfo()
    }
    
    func setGamePlayInfo() {
        let strHowToPlay = "Users can join the contest by paying the entry fees mentioned at the dashboard . Numbers and colours randomly rotating freezes down at the time of the live contest . User has to add the value in the blue box , subtract the value in the red box and ignore / nullify the value in the green box . Users have to place their judgement over the calculation of the total by adding , subtracting and ignoring the values in the boxes . A user will have 30 secs to place their answer . Though the winnings are  strictly based on speed . Maximum numbers of winners will be showcased before the contest goes live . For e,g , in a contest with 1000 tickets , the system has announced maximum winners as 300 . So , in this case , fastest 300 tickets with  the right answer will take back the winnnings. \n\nFor e.g [green 700] [ [blue (850 ].   [ red 300 ]\n= (0 x 700) + 850 - 300\n= 550 \n\nSo the answer is 550. \nThis is an example of just 3 grids . If there would be 4th grid as [ red 950 ] . Then the answer would be\n\n(0 x 700) + 850 - 300 - 950\n= 0 + 850 - 300 - 950\n= -400 \n\nNote :-  the sum of the calculation can be in positive negative or 0 as well.\n\nContests can be either if easy mode (20 grids ) / moderate mode (32 grids) / pro mode (40grids)\n\nNote :- this info will be placed on dashboard before u join the contests.\n\nAbbreviations :-\nE - easy mode.\nM - moderate mode.\nP - pro mode\nFlexi - flexi bar (game mode 1).\nFix - fix slots (game mode 2)"
        labelHowToPlay.text = strHowToPlay
    }
    
    //MARK: - Button Mthod
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
