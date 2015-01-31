//
//  DetailViewController.swift
//  WeatherGuru
//
//  Created by Aida Zhumabekova on 11/18/14.
//  Copyright (c) 2014 Aida Zhumabekova. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Outlets

    
    @IBOutlet weak var degreeControl: UISegmentedControl!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    var city: String = ""
    var urlSession: NSURLSession!
    var data = NSMutableData()
    var degree: String = "metric"
    var point: String = " C°"
    var masterViewController: MasterViewController?
    
    // MARK: - Variables
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
            if isViewLoaded(){
                getWeatherData()
            }
        }
    }
    enum OperationType{
        case Cels
        case Farn
    }
    var operatinonType=OperationType.Cels
    
    

    
  // MARK: - Functions
    //detect if city name has a whitespace
    func spaceDetect(){
        let whitespace = NSCharacterSet.whitespaceCharacterSet()
        
        let range = city.rangeOfCharacterFromSet(whitespace)
        
        // range will be nil if no whitespace is found
        if let test = range {
         city = city.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
    }
    func getWeatherData(){
        spaceDetect()
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=" + city + "&APPID=c8454fac2818dbea064d6638345a7564&units=" + degree
        
        var url: NSURL = NSURL(string: urlString)
        
        let dataTask = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if let parsedData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary{
                
                if let error = parsedData["message"] as? String{
                    let alert = UIAlertController(title: "Server response", message: "City not found", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    self.navigationController?.popViewControllerAnimated(true)
                    self.masterViewController?.removeLocation(self.city)
                    
                }
                else{
                    let weatherArray = parsedData["weather"] as NSArray
                    let weatherDict = weatherArray.firstObject! as NSDictionary
                    let desc = weatherDict["description"] as String
                    let icon = weatherDict["icon"] as String
                    
                    let tempDict = parsedData["main"] as NSDictionary
                    let temp = tempDict["temp"] as NSNumber
                    let tempString = "\(temp.doubleValue)"
                    
                    let tempMin = tempDict["temp_min"] as NSNumber
                    let tempMax = tempDict["temp_max"] as NSNumber
                    let tempMinString = "\(tempMin.integerValue)"
                    let tempMaxString = "\(tempMax.integerValue)"
                    
                    self.setLabels(desc, icon: icon, temp: tempString, tempMin: tempMinString, tempMax: tempMaxString)
                }
               
            }
        })
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        dataTask.resume()
    }
    
    func setLabels(description:String, icon:String, temp:String, tempMin:String,tempMax:String ){
        //capitilize string
        let first = description.startIndex
        let rest = advance(first,1)..<description.endIndex
        let capitalised = description[first...first].uppercaseString + description[rest]
        
        detailDescriptionLabel.text = capitalised
        detailImageView.image = UIImage(named: icon)
        tempLabel.text = temp + point
        minLabel.text = tempMin + point
        maxLabel.text = tempMax + point
        
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            //if let label = self.detailDescriptionLabel {
                if(detail.description == nil){
                    navigationItem.title = city
                }
                else{
                    navigationItem.title = detail.description
                }
                city = detail.description
           // }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        degreeControl.selectedSegmentIndex=0
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSession = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        city = "Budapest"
        self.configureView()
        getWeatherData()
    }
    
    // MARK: - Actions
    
    
    @IBAction func degreeChanged(sender: AnyObject) {
        switch degreeControl.selectedSegmentIndex{
        case 0:
            operatinonType = .Cels
            degree = "metric"
            point = " C°"
        case 1:
            operatinonType = .Farn
            degree = "imperial"
            point = " F°"
        default:
            operatinonType = .Cels
        
        }
        //reload
        getWeatherData();
        

    }
    

}

