# ALPHACamp_finalAssessment_Q5

## Data Source
臺北市立動物園_動物資料  
Taipei Gov Open Data: Animal of Taipei Zoo  
http://data.taipei/opendata/datalist/datasetMeta?oid=5cb73231-b741-48b3-bec3-2ef57bb10029  

## App Screen
![Alt text](launching.jpg?raw=true "launching")
![Alt text](mainScreen.jpg?raw=true "mainScreen")
![Alt text](insertedRecord.jpg?raw=true "insertedRecord")
![Alt text](updatedScreen.jpg?raw=true "updatedScreen")   

## About data
There are 2 streams of data, one is from data taipei api's record, another one is inserted by user. 

App's flow: load of local records (if any) -> internet records from data taipei  

So how to organise the sequence among records? I created a sequece number variable for records. For example, I have 5 rows of local data, at the app start, I will check the UserDefaults to determine how many local data records in the app, at this time is 5, so I use a for loop to grep local data from 0..<5 and insert into data array, object's id are from 0 to 4, then, I grep data from internet, and assign each of their id start from 5..and so on. But be mind that, the sequece number at controller is stop at 5, what is assigned is the object's id variable, but actually no use in this case, just for formalise something. 

Ok, so what will happen at insertion? At insertion, I will check the current sequence number, at this time is 5, I will save the image at naming /5.jpg and set a UserDefault object 'idNameOf5' for saving it's description, also very important, update the UserDefaults of current loop is now at 6, so when the app open next time, it will loop the local data from 0..<6 and start to grep internet data and assign their object id from 7...so on

## TableView Controller

### Data grep
```swift
func getData() {
        // show label
        HUD.show(.LabeledProgress(title: "動物集合中", subtitle: "請稍候。。。"))
        // remove cache
        allAnimalInfoWohooooo.removeAll()
        // get sequence number
        userInsertionIDSequence = NSUserDefaults.standardUserDefaults().integerForKey("insertionID")
        // load local data
        if NSUserDefaults.standardUserDefaults().objectForKey("nameOfID0") != nil {
            for loop in 0..<userInsertionIDSequence {
                let eachAnimal = animalInfo()
                eachAnimal.id = loop
                eachAnimal.name = String(NSUserDefaults.standardUserDefaults().objectForKey("nameOfID\(loop)")!)
                eachAnimal.pic = NSHomeDirectory().stringByAppendingString("/Documents/\(loop).jpg")
                allAnimalInfoWohooooo.append(eachAnimal)
            }
        }
        // reverse order to show from update to old
        allAnimalInfoWohooooo = allAnimalInfoWohooooo.reverse()
        // load internet data
        getAnimalInfoAPI_Call { (result) in
            var currentID = self.userInsertionIDSequence
            let animals = result["result"]["results"].arrayValue
            for animal in animals {
                let eachAnimal = animalInfo()
                eachAnimal.id = currentID
                eachAnimal.name = animal["A_Name_Ch"].stringValue
                eachAnimal.pic = animal["A_Pic01_URL"].stringValue
                self.allAnimalInfoWohooooo.append(eachAnimal)
                currentID += 1
            }
            // reload, remove loading label
            self.tableView.reloadData()
            HUD.hide()
        }
    }
```
logic sequece: show loading lable -> clear array items -> get local data rows number at UserDefaults -> for loop local data -> reverse order (from update to outdate) -> grep internet data and insert into array -> realod table view -> hide loading label

### showing content
```swift
override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Main_TableViewCell", forIndexPath: indexPath) as! Main_TableViewCell
        indexPath.row >= userInsertionIDSequence ? (cell.animalPic.sd_setImageWithURL(NSURL(string: allAnimalInfoWohooooo[indexPath.row].pic!))) : (cell.animalPic.image = UIImage(data: NSData(contentsOfFile: allAnimalInfoWohooooo[indexPath.row].pic!)!, scale: 1.0))
        cell.animalName.text = allAnimalInfoWohooooo[indexPath.row].name
        return cell
    }
```
nothing special but one thing, as local data's image save on local (...i don't know what i'm talking about...), and data taipei's record image are on internet, in cell, you have to determine which are local and which are from internet and use different method to grep and display.

## Insertion ViewController

### viewDidLoad
```swift
override func viewDidLoad() {
        super.viewDidLoad()
        
        insertPicFrame.layer.borderColor = UIColor.orangeColor().CGColor
        insertPicFrame.layer.borderWidth = 1
        insertNameTextfield.layer.borderColor = UIColor.orangeColor().CGColor
        insertNameTextfield.layer.borderWidth = 1
        confirmToAddButton.layer.borderColor = UIColor.orangeColor().CGColor
        confirmToAddButton.layer.borderWidth = 1
        
        // default to open camera when view load
        takePhotoAction(self)
    }
 ```
 nothing special on top, just some appearance settings, the important is load of camera action when view begin (press + button at previous controller)
 
 ### image taking
 ```swift
 func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.insertPicFrame.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func takePhotoAction(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .Camera
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
 ```
 functions to take photos and to display on uiimageview
 
 ### confirm to add action
 ```swift
     @IBAction func confirmToAddAction(sender: AnyObject) {
        insertPicFrame.image != nil && insertNameTextfield.hasText() ? dataPassBack() : invalidInputWarning()
    }
    
    func dataPassBack() {
        insertionDelegate?.sendDataToPreviousVC(insertNameTextfield.text!, pic: insertPicFrame.image!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func invalidInputWarning() {
        let alertController = UIAlertController(title: "資料還沒填妥喔", message: "請確定已插入照片與動物名稱！", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "OK", style: .Destructive, handler: nil)
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
 ```
 when button pressed, it run function confirmToAddAction, it check value of image fame and text field to see whether they both contain data, if no, run invalidInputWarning to warn user, if yes, pass back data by delegate
 
 ### delegate protocol
 ```swift
 protocol passInsertionBack: class
{
    func sendDataToPreviousVC(name:String, pic:UIImage)
}
```
simple delegation, pass back name string and image in UIImage

### conforming protocol at main TableViewController
```swift
func sendDataToPreviousVC(name: String, pic: UIImage) {
        // save image to file
        let image:NSData = UIImageJPEGRepresentation(pic, 1)!
        let imagePath = NSHomeDirectory().stringByAppendingString("/Documents/\(userInsertionIDSequence).jpg")
        image.writeToFile(imagePath, atomically: true)
        // save image name to nsdefaults
        NSUserDefaults.standardUserDefaults().setObject(name, forKey: "nameOfID\(userInsertionIDSequence)")
        // update sequence
        userInsertionIDSequence += 1
        NSUserDefaults.standardUserDefaults().setInteger(userInsertionIDSequence, forKey: "insertionID")
        NSUserDefaults.standardUserDefaults().synchronize()
        //
        getData()
    }
 ```
in this delegate function, it take both data into local saving, and to reload the table view that same from app start
