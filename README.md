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

