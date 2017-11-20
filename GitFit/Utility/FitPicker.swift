import UIKit

struct FitPickerItem {
    var text: String?
    var id: Int?
}

protocol FitPickerDelegate {
    func userHitDone(selectedRow: Int)
}

class FitPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    var selected: Int?
    var textfield: UITextField?
    var pickerData: [FitPickerItem] = []
    var fitDelegate: FitPickerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.dataSource = self
        self.delegate = self
    }
    
    init(textfield: UITextField, pickerData: [FitPickerItem]) {
        self.init()
        self.textfield = textfield
        self.textfield?.inputView = self
        self.pickerData = pickerData
        if pickerData.count > 0 {
            self.selectRow(0, inComponent: 0, animated: false)
            textfield.text = pickerData[0].text
            selected = 0
        }
        setTextfieldArrow()
        setPickerStyle()
        setPickerToolBar()
    }
    
    func setTextfieldArrow() {
        textfield?.tintColor = .clear
        textfield?.rightViewMode = .always
        let arrow = UIImageView(image: #imageLiteral(resourceName: "down_arrow"))
        if let size = arrow.image?.size {
            arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 10.0, height: size.height)
        }
        arrow.contentMode = .center
        textfield?.rightView = arrow
    }
    
    func setPickerStyle() {
        self.backgroundColor = .white
        self.showsSelectionIndicator = true
    }
    
    func setPickerToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        //toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        textfield?.inputAccessoryView = toolBar
    }
    
    @objc func donePicker() {
        selected = self.selectedRow(inComponent: 0)
        fitDelegate?.userHitDone(selectedRow: selected!)
        textfield?.resignFirstResponder()
    }
    
    @objc func cancelPicker() {
        if let selected = selected {
            self.selectRow(selected, inComponent: 0, animated: false)
            textfield?.text = pickerData[selected].text
        } else {
            textfield?.text = ""
        }
        textfield?.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textfield?.text = pickerData[row].text
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "Avenir", size: 20)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = pickerData[row].text
        
        return pickerLabel!;
    }
    
    func set(with value: String) {
        for i in 0...pickerData.count - 1{
            if pickerData[i].text == value {
                self.selectRow(i, inComponent: 0, animated: false)
                selected = i
            }
        }
    }
}

