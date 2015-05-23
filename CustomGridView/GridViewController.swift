//  Created by Amine Chaouki on 10/05/15.
//  Copyright (c) 2015 chaouki. All rights reserved.
//

import UIKit

//Section = row, item = column
public class ContentGridViewCell: UICollectionViewCell {
    @IBOutlet public weak var contentLabel: UILabel!

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

public class TitleGridViewCell: UICollectionViewCell {
    @IBOutlet public weak var contentLabel: UITextField!

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}



public class GridViewController: UICollectionViewController {
//    let titleCellIdentifier = "TitleCellIdentifier"
//    let contentCellIdentifier = "ContentCellIdentifier"

    public var dataSource: GridViewLayoutDataSource!


    @IBOutlet weak var layout: GridViewLayout!


    public override func viewDidLoad() {
        super.viewDidLoad()
        

        layout = collectionViewLayout as! GridViewLayout
        layout.dataSource = dataSource

    }


    // MARK - UICollectionViewDataSource

    public override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataSource.numberOfRows() + dataSource.numberOfColumnTitles()

    }


    public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfColumns() + dataSource.numberOfRowTitles()
    }


    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let row = indexPath.section
        let column = indexPath.item

        switch (row, column) {
        case (0..<dataSource.numberOfColumnTitles(), 0..<dataSource.numberOfRowTitles()):
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(dataSource.contentCellID(), forIndexPath: indexPath) as! ContentGridViewCell
            dataSource.configureCornerCell(cell, cornerColumnNumber: column, cornerRowNumner: row)
            return cell

        case (_, 0..<dataSource.numberOfRowTitles()):
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(dataSource.titleCellID(), forIndexPath: indexPath)
                as! TitleGridViewCell
            dataSource.configureRowTitleCell(cell, rowtitleCellNumber: column, rowIndex: row - dataSource.numberOfColumnTitles())
            return cell

        case (0..<dataSource.numberOfColumnTitles(), _):
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(dataSource.titleCellID(), forIndexPath: indexPath) as! TitleGridViewCell
            dataSource.configureColumnTitleCell(cell, columnTitleCellNumber: row, columnIndex: column - dataSource.numberOfRowTitles())
            return cell

        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(dataSource.contentCellID(), forIndexPath: indexPath) as! ContentGridViewCell
            dataSource.configureContentCell(cell, columnIndex: column - dataSource.numberOfColumnTitles(), rowIndex: row - dataSource.numberOfColumnTitles())
            return cell

        }
    }
}


