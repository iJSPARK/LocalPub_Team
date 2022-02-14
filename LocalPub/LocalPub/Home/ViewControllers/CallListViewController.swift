//
//  CallListViewController.swift
//  LocalPubHome
//
//  Created by Serang MacBook Pro 16 on 2022/02/06.
//

import UIKit
import CoreData
//import FirebaseStorage

class CallListViewController: UIViewController {
    
    //var callList: [CallList] = []
    var callList: [CallList] = [CallList]() {
        didSet {
            updateView()
        }
    }

    let myUserDefaults = UserDefaults.standard
    
    lazy var cache: NSCache<AnyObject, UIImage> = NSCache()
    
    let entityName: String = "CallList"
    
    private var isCellView: Bool = false
    
    //var container: NSPersistentContainer!
    private let container = NSPersistentContainer( name: "LocalPub" )
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    @IBOutlet var navCallList: UINavigationItem!
    @IBOutlet var callListTable: UITableView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        callListTable.delegate = self
        callListTable.dataSource = self
        
        container.loadPersistentStores { (
            persistentStoreDescription, error ) in
            
            if let error = error {
                print( "Unable to load Persistent Store" )
                print( "\(error), \(error.localizedDescription)" )
            
            } else {

                self.SetLocalized()
                
                self.updateView()
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //print( "Tab: \(self.tabBarController!.selectedIndex)" )
        //print( "isCellView: \(isCellView)" )

        if !isCellView {
            fetchCallList()
        }

        isCellView = false
    }
    
    func SetLocalized() {
        
        navCallList.title = "CallList".localized()
        messageLabel.text = "NotAnyCalls".localized()
    
    }
    
    private func updateView() {
        
        let hasCalls = callList.count > 0
        
        callListTable.isHidden = !hasCalls
        messageLabel.isHidden = hasCalls
        
        activityIndicatorView.stopAnimating()
    }
    
    @IBAction func unwindToCallList(_ segue: UIStoryboardSegue ) {

//        if let sourceVC = segue.source as? CallViewController {
//            print("callName: \(sourceVC.callName!)")
//        }
        
    }
    
    private func fetchCallList() {
        
        let idSort: NSSortDescriptor = NSSortDescriptor( key: "callDate", ascending: false )
        let fetchRequest: NSFetchRequest<NSManagedObject>
            = NSFetchRequest<NSManagedObject>( entityName: entityName )
        
        fetchRequest.sortDescriptors = [idSort]
        
        do {

            if let fetchResult: [CallList] = try context!.fetch(fetchRequest) as? [CallList] {

                callList = fetchResult

                //print( "collList: \(callList)")
                print( "CallList Count: \(callList.count)" )

//               callList.forEach { call in
//                   print( call.callUID! )
//                    print( call.callDate! )
//                   print( call.callName! )
//                    print( call.callGender )
//                    print( call.callTime )
//                    print( call.callImage! )
//                    print( "\n" )
//                }

                callListTable.reloadData()
            }

        } catch let error as NSError {
            print("Could not fetch: \(error), \(error.userInfo)")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let indexPath = self.callListTable.indexPathForSelectedRow,
            let RVC = segue.destination as? CallViewController {
            
            RVC.call = callList[indexPath.row]
            
            isCellView = true

        }
    }
    
}

extension CallListViewController: UITableViewDelegate {

    // deselect row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}

extension CallListViewController: UITableViewDataSource {
    
    // height of header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    // contents of header
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return data[section][0][0]
//    }
    
    // num of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // num of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callList.count
    }
    
    // cell design
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CallListTableViewCell.reuseIdentifier, for: indexPath) as? CallListTableViewCell else {
            fatalError("Unexpected Index Path")
        }

        // Fetch Quote
        let call = callList[indexPath.row]

        // Configure Cell
        cell.callNameLabel.text = call.callName!
        
        let dateform = DateFormatter()
        dateform.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        cell.callDateLabel.text = "CallDate".localized() +
        ": \(dateform.string( from: call.callDate!) )"
        
        cell.callTimeLabel.text = "CallTime".localized() +
        ": \(call.callTime)"
        
        // Image 재로딩 방지 Cache
//        if ( cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil) {
//
//            cell.imageView?.image = cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject)
//
//        } else {

            cell.imageView?.image = UIImage(named: "placeholder.png")
            
            let filePath = "/all_90/\(call.callUID!)_90.jpg"
            downloadUserImageURL( filePath ) { url in
                    
                let data = NSData( contentsOf: url! )
                let image = UIImage( data: data! as Data )
                
//                self.cache.setObject( image!, forKey: (indexPath as NSIndexPath).row as AnyObject )
                
                //print( "cell height: \(cell.callImage?.frame.height)" )
                //print( "cell width: \(cell.callImage?.frame.width)" )
                //cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.height)!/2
                cell.imageView?.layer.cornerRadius = 45
                cell.imageView?.layer.borderWidth = 1
                cell.imageView?.clipsToBounds = true
                cell.imageView?.layer.borderColor = UIColor.clear.cgColor
                
                tableView.beginUpdates()
                cell.imageView?.image = image
                tableView.endUpdates()
            
            }
    
//        }
        
        return cell
    
    }
        
}


class CallListTableViewCell: UITableViewCell {

    static let reuseIdentifier = "CallListCell"
    
    @IBOutlet var callImage: UIImageView!
    @IBOutlet var callNameLabel: UILabel!
    @IBOutlet var callDateLabel: UILabel!
    @IBOutlet var callTimeLabel: UILabel!
    
    var finishReload: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
