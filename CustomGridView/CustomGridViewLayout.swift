//
//  CustomCollectionViewLayout.swift
//  CustomCollectionLayout
//
//  Created by JOSE MARTINEZ on 15/12/2014.
//  Copyright (c) 2014 brightec. All rights reserved.
//

import UIKit

//Section = row, item = column

public class CustomGridViewLayout: UICollectionViewLayout {

    var itemAttributes = [[UICollectionViewLayoutAttributes]]()
    var contentSize : CGSize!
    var dataSource: CustomGridViewLayoutDataSource!
    let sizeCache = NSCache()


    public func reset() {
        sizeCache.removeAllObjects()
    }

    override public func prepareLayout() {
        if self.collectionView?.numberOfSections() == 0 {
            return
        }

        if (self.itemAttributes.count > 0){
            for row in 0..<self.collectionView!.numberOfSections() {
                var numberOfColumns : Int = self.collectionView!.numberOfItemsInSection(row)
                for column in 0..<numberOfColumns {
                    if row >= dataSource.numberOfColumnTitles() && column >= dataSource.numberOfRowTitles() {
                        continue
                    }

                    var attributes : UICollectionViewLayoutAttributes = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: column, inSection: row))

                    if row < dataSource.numberOfColumnTitles() {
                        var frame = attributes.frame
                        frame.origin.y = self.collectionView!.contentOffset.y
                            + CGFloat(row) * dataSource.heightOfColumnTitles()
                        attributes.frame = frame
                    }

                    if column < dataSource.numberOfRowTitles() {
                        var frame = attributes.frame
                        frame.origin.x = self.collectionView!.contentOffset.x
                            + CGFloat(column) * dataSource.widthOfRowTitles()
                        attributes.frame = frame
                    }
                }
            }
            return
        }

        var column = 0
        var xOffset : CGFloat = 0
        var yOffset : CGFloat = 0
        var contentWidth : CGFloat = 0
        var contentHeight : CGFloat = 0

        for section in 0..<self.collectionView!.numberOfSections() {
            var sectionAttributes = [UICollectionViewLayoutAttributes]()
            var numberOfItems : Int = self.collectionView!.numberOfItemsInSection(section)
            for index in 0..<numberOfItems {

                var itemSize = self.sizeOfItemAtIndexPath(NSIndexPath(forRow: index, inSection: section))

                var indexPath = NSIndexPath(forItem: index, inSection: section)
                var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height))

                if section < dataSource.numberOfColumnTitles() && index < dataSource.numberOfRowTitles() {
                    attributes.zIndex = 1024;
                } else  if section < dataSource.numberOfColumnTitles() || index < dataSource.numberOfRowTitles() {
                    attributes.zIndex = 1023
                }

                if section < dataSource.numberOfColumnTitles() {
                    var frame = attributes.frame
                    frame.origin.y = self.collectionView!.contentOffset.y
                        + CGFloat(section) * dataSource.heightOfColumnTitles()

                    attributes.frame = frame
                }
                if index < dataSource.numberOfRowTitles() {
                    var frame = attributes.frame
                    frame.origin.x = self.collectionView!.contentOffset.x
                        + CGFloat(index) * dataSource.widthOfRowTitles()

                    attributes.frame = frame
                }

                sectionAttributes.append(attributes)

                xOffset += itemSize.width
                column++

                if column == numberOfItems {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }

                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height
                }
            }

            self.itemAttributes.append(sectionAttributes)
        }

        var attributes : UICollectionViewLayoutAttributes = self.itemAttributes.last!.last!
        contentHeight = attributes.frame.origin.y + attributes.frame.size.height
        self.contentSize = CGSizeMake(contentWidth, contentHeight)
    }

    override public func collectionViewContentSize() -> CGSize {
        return self.contentSize
    }

    override public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return self.itemAttributes[indexPath.section][indexPath.row]
    }

    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var attributes : NSMutableArray = NSMutableArray()
        for section in self.itemAttributes {
            attributes.addObjectsFromArray(
                section.filter({(attributes: UICollectionViewLayoutAttributes) -> Bool in
                    return CGRectIntersectsRect(rect, attributes.frame)
                })
            )}


    return attributes as [AnyObject]
    }

    override public func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }


    func sizeOfItemAtIndexPath(indexPath: NSIndexPath) -> CGSize {

        if let size = sizeCache.objectForKey(indexPath)?.CGSizeValue() {
            return size
        }


        let size: CGSize
        let column = indexPath.item
        let row = indexPath.section
        switch (row, column) {
        case (0..<dataSource.numberOfColumnTitles(), 0..<dataSource.numberOfRowTitles()):
            size = CGSize(width: dataSource.widthOfRowTitles(), height: dataSource.heightOfColumnTitles())
        case (_, 0..<dataSource.numberOfRowTitles()):
            size = CGSize(width: dataSource.widthOfRowTitles(), height: dataSource.heightForContentRowIndex(row - dataSource.numberOfColumnTitles()))
        case (0..<dataSource.numberOfColumnTitles(), _):
            size = CGSize(width: dataSource.widthForContentColumnIndex(column - dataSource.numberOfRowTitles()), height: dataSource.heightOfColumnTitles())
        default:
            size = CGSize(width: dataSource.widthForContentColumnIndex(column - dataSource.numberOfRowTitles()), height: dataSource.heightForContentRowIndex(row - dataSource.numberOfColumnTitles()))
        }
        
        sizeCache.setObject(NSValue(CGSize: size), forKey: indexPath, cost: 1)
        return size
    }
}