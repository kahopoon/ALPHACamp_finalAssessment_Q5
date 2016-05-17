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
