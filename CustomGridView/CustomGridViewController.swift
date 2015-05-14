//
//  CollectionViewController.swift
//  CustomCollectionLayout
//
//  Created by JOSE MARTINEZ on 15/12/2014.
//  Copyright (c) 2014 brightec. All rights reserved.
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

public class CustomGridViewController: UICollectionViewController {
    let titleCellIdentifier = "TitleCellIdentifier"
    let contentCellIdentifier = "ContentCellIdentifier"

    public var dataSource: CustomGridViewLayoutDataSource!


    @IBOutlet weak var layout: CustomGridViewLayout!


    public override func viewDidLoad() {
        super.viewDidLoad()
        

        layout = collectionViewLayout as! CustomGridViewLayout
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
            return dataSource.cornerCell(indexPath: indexPath)
        case (_, 0..<dataSource.numberOfRowTitles()):
            return dataSource.rowTitleCell(titleCellNumber: column, rowIndex: row - dataSource.numberOfColumnTitles(), indexPath: indexPath)
        case (0..<dataSource.numberOfColumnTitles(), _):
            return dataSource.columnTitleCell(titleCellNumber: row, columnIndex: column - dataSource.numberOfRowTitles(), indexPath: indexPath)
        default:
            return dataSource.contentCell(columnIndex: column - dataSource.numberOfColumnTitles(), rowIndex: row - dataSource.numberOfColumnTitles(), indexPath: indexPath)

        }
    }
}


