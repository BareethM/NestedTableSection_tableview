//
//  ViewController.swift
//  NestedSection
//
//  Created by Fusion Innovative Ltd on 04/05/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    var sections:[Section] = [Section(title: "Snacks", isExpanded: true, subSection: [SubSection(title: "Shawarma", row: [Row(title: "Chicken Shawarma"),Row(title: "Beef Shawarma"),Row(title: "Mutton Shawarma"),Row(title: "Veg Shawarma")]),SubSection(title: "Pizza", row: [Row(title: "Veggie Pizza"),Row(title: "Pepperoni Pizza"),Row(title: "Meat Pizza."),Row(title: "Margherita Pizza"),Row(title: "BBQ Chicken Pizza"),Row(title: "Hawaiian Pizza"),Row(title: "Buffalo Pizza.")])]),
        Section(title: "Cricket", isExpanded: true, subSection: [SubSection(title: "New Zealand",row: [Row(title: "Kane Williamson")]),SubSection(title: "India",  row: [Row(title: "Sachin Tendulkar"),Row(title: "MS Dhoni"),Row(title: "Raina"),Row(title: "Jadeja"),Row(title: "Kohli")]),SubSection(title: "Australia",  row: [Row(title: "Warner"),Row(title: "Starc"),Row(title: "Finch")]),SubSection(title: "England",  row: [Row(title: "Stokes"),Row(title: "Buttler"),Row(title: "Moeen Ali")])])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewCell()
    }
    
    // MARK: Register table view and protocals
    func setTableViewCell(){
        tblView.register(UINib(nibName: "SectionCell", bundle: nil), forCellReuseIdentifier: "SectionCell")
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.reloadData()
    }

}

extension ViewController: UITableViewDataSource {
    
// MARK: Add subsection and row
    func getNumberOfRows(section: Int) -> Int {
        let sectionItems = sections[section]
        var numberOfRows = sectionItems.subSection.count  // For second level section headers
        
        sectionItems.subSection.forEach { subSection in
            numberOfRows += subSection.row.count // For actual table rows
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let sectionItem = sections[section]
            return sectionItem.isExpanded ? getNumberOfRows(section: section) : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionCell
        let itemAndSubsectionIndex: IndexPath? = computeItemAndSubsectionIndex(for: indexPath)
        let subsectionIndex = Int(itemAndSubsectionIndex?.section  ?? 0)
        let itemIndex: Int? = itemAndSubsectionIndex?.row
        
        if (itemIndex ?? 0) < 0 {
            // Section header
            cell.contentView.backgroundColor = .blue
            cell.ttlLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
            cell.ttlLbl.textColor = .white
            cell.ttlLbl.text = sections[indexPath.section].subSection[subsectionIndex ].title
        } else {
            // Row Item
            cell.contentView.backgroundColor = .green
            cell.ttlLbl.font = .boldSystemFont(ofSize: 10)
            cell.ttlLbl.textColor = .black
            cell.ttlLbl.text = sections[indexPath.section].subSection[subsectionIndex].row[itemIndex ?? 0].title
        }
           
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // MARK: * To change the index *
    func computeItemAndSubsectionIndex(for indexPath: IndexPath?) -> IndexPath? {
        let sectionItems = sections[Int((indexPath?.section ?? 0) )]
        var itemIndex: Int? = indexPath?.row
        var subsectionIndex: Int = 0
        for i in 0..<sectionItems.subSection.count{
            
            itemIndex = (itemIndex ?? 0) - 1
            
            let subsectionItems = sectionItems
            if (itemIndex ?? 0) < Int(subsectionItems.subSection[i].row.count ) {
                subsectionIndex = i
                break
            } else {
                itemIndex! -= subsectionItems.subSection[i].row.count
            }
        }
        return IndexPath(row: itemIndex ?? 0, section: subsectionIndex)
    }

  }


extension ViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionItem = sections[section]
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25))
        sectionView.backgroundColor = UIColor.magenta
        let sectionName = UILabel(frame: CGRect(x: 5, y: 0, width: tableView.frame.size.width, height: 25))
        sectionName.text = sectionItem.title
        sectionName.textColor = UIColor.white
        sectionName.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        sectionName.textAlignment = .left
        sectionView.addSubview(sectionName)
        
        // Add tap gesture recognizer to header view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sectionHeaderTapped(_:)))
        sectionView.addGestureRecognizer(tapGestureRecognizer)
        sectionView.tag = section
        return sectionView
    }
    
    //MARK: For Expand Action
    @objc func sectionHeaderTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let section = gestureRecognizer.view?.tag else { return }
        sections[section].isExpanded.toggle()
        tblView.reloadData()
    }
    
}


struct Section {
    var title:String
    var isExpanded:Bool
    var subSection:[SubSection]
}
struct SubSection {
    var title:String
    var row:[Row]
}
struct Row {
    var title:String
}


class SectionCell:UITableViewCell{
    @IBOutlet weak var ttlLbl: UILabel!
}
