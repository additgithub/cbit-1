import UIKit

// MARK: - MyDropDown Protocol
public protocol MyDropDownDelegate{
    func recievedSelectedValue(name:String, index: Int)
}

// MARK: - DropDown Class.
public class MyDropDown: UIView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties.
    var delegate: MyDropDownDelegate?
    var dropDownTable: UITableView?
    var dropDownButton: UIButton?
    var dropDownButtonFrame: CGRect?
    var dropDownDirection: String?
    var dropDownHeight: CGFloat?
    
    var dropDownItem = [String]()
    var dropDownImageItem = [UIImage]()
    
    // MARK: - Default Method.
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initTable()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    open func initTable(){
        self.isUserInteractionEnabled = true
        self.dropDownTable = UITableView ()
        self.dropDownTable?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.dropDownTable?.delegate=self
    }
    
    // MARK: - Show DropDown Method.
    open func showMyDropDown(sendButton: UIButton, height: CGFloat, arrayList: [String]?, imageList: [UIImage]?, direction: String){
        dropDownButton = sendButton
        dropDownButtonFrame = sendButton.frame
        dropDownHeight = height
        dropDownDirection = direction
        if let arrayList = arrayList {
            dropDownItem = arrayList
        }
        
        if let imageList = imageList {
            dropDownImageItem = imageList
        }
        
        if dropDownDirection == "Down" {
            self.frame = CGRect(x: dropDownButtonFrame!.origin.x, y: dropDownButtonFrame!.origin.y + dropDownButtonFrame!.size.height, width: dropDownButtonFrame!.size.width, height: 0)
            self.layer.shadowOffset = CGSize(width:-1, height:1)
        } else if dropDownDirection == "Up" {
            self.frame = CGRect(x: dropDownButtonFrame!.origin.x, y: dropDownButtonFrame!.origin.y, width: dropDownButtonFrame!.size.width, height: 0)
            self.layer.shadowOffset = CGSize(width:-1, height:-1)
        }
        
        self.layer.masksToBounds = false;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        dropDownTable?.frame = CGRect(x:0, y:0, width:self.frame.size.width, height:0)
        dropDownTable?.delegate = self
        dropDownTable?.dataSource = self
        dropDownTable?.layer.cornerRadius = 5
        dropDownTable?.backgroundColor = UIColor.white
        dropDownTable?.separatorStyle = .singleLine
        dropDownTable?.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        dropDownTable?.separatorColor = UIColor.black
        dropDownTable?.showsHorizontalScrollIndicator = false
        dropDownTable?.showsVerticalScrollIndicator = false
        
       UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
        if self.dropDownDirection == "Down" {
            self.frame = CGRect(x: self.dropDownButtonFrame!.origin.x, y: self.dropDownButtonFrame!.origin.y + self.dropDownButtonFrame!.size.height, width: self.dropDownButtonFrame!.size.width, height: self.dropDownHeight!)
        } else if self.dropDownDirection == "Up" {
            self.frame = CGRect(x: self.dropDownButtonFrame!.origin.x, y: self.dropDownButtonFrame!.origin.y - self.dropDownHeight!, width: self.dropDownButtonFrame!.size.width, height: self.dropDownHeight!)
        }
        self.dropDownTable?.frame = CGRect(x:0, y:0, width:self.frame.size.width, height:self.dropDownHeight!)
       }, completion: nil)
        
        sendButton.superview?.addSubview(self)
        self.addSubview(dropDownTable!)
    }
    
    // MARK: - Hide DropDown Method.
    open func hideMyDropDown(sendButton: UIButton){
        dropDownButton = sendButton
        dropDownButtonFrame = sendButton.frame
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
            if self.dropDownDirection == "Down" {
                self.frame = CGRect(x: self.dropDownButtonFrame!.origin.x, y: self.dropDownButtonFrame!.origin.y + self.dropDownButtonFrame!.size.height, width: self.dropDownButtonFrame!.size.width, height: 0)
            } else if self.dropDownDirection == "Up" {
                self.frame = CGRect(x: self.dropDownButtonFrame!.origin.x, y: self.dropDownButtonFrame!.origin.y, width: self.dropDownButtonFrame!.size.width, height: 0)
            }
            self.dropDownTable?.frame = CGRect(x:0, y:0, width:self.frame.size.width, height:0)
        }, completion:{ Void in
                self.removeFromSuperview()
        })
    }
    
    // MARK: - TableView Methods.
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dropDownItem.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.textAlignment = .center
        if dropDownImageItem.isEmpty {
            cell.textLabel?.text = dropDownItem[indexPath.row]
        } else {
            cell.imageView?.image = dropDownImageItem[indexPath.row]
            cell.textLabel?.text = dropDownItem[indexPath.row]
        }
        
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.recievedSelectedValue(name: dropDownItem[indexPath.row], index: indexPath.row)
    }
}
