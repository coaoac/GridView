# GridView

GridView builds on the excellent CustomCollectionViewLayout which can be found here https://github.com/brightec/CustomCollectionViewLayout to provide an API both easy to use and more flexible.

## Usage
GridViewController is a subclass of UICollectionViewController which needs to be used in conjunction with the custom layout GridViewLayout which is also included in the framework.

After that all you need is implement the GridViewLayoutDataSource protocol:

func numberOfColumns() ->  Int // does not include the title columns

func numberOfRows() -> Int // does not include the title rows

func numberOfRowTitles() -> Int

func numberOfColumnTitles() -> Int

func widthForContentColumnIndex(columnIndex: Int) -> CGFloat

func heightForContentRowIndex(rowIndex: Int) -> CGFloat

func heightOfColumnTitles() -> CGFloat

func widthOfRowTitles() -> CGFloat

func cornerCellForIndexPath(indexPath: NSIndexPath,cornerColumnIndex: Int, cornerRowIndex: Int) -> UICollectionViewCell

func columnTitleCellForIndexPath(indexPath: NSIndexPath, columnTitleCellIndex: Int, columnIndex: Int) -> UICollectionViewCell

func rowTitleCellForIndexPath(indexPath: NSIndexPath, rowtitleCellIndex: Int, rowIndex: Int) -> UICollectionViewCell

func contentCellForIndexPath(indexPath: NSIndexPath, columnIndex: Int, rowIndex: Int) -> UICollectionViewCell


Enjoy!



