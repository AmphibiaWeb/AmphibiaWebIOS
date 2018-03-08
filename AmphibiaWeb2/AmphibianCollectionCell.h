//
//  AmphibianCollectionCell.h
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 6/11/13.
//  Copyright (c) 2013 Mel Roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AmphibianImage.h"

@protocol AmphibianCollectionCellDelegate <NSObject>
@required
-(void)imageLoaded:(NSData *)imageData andID:(NSString *)identification;
@end

@interface AmphibianCollectionCell : UICollectionViewCell<AmphibianImageDelegate>
{
    id <AmphibianCollectionCellDelegate> delegate;
}

@property ( nonatomic) id <AmphibianCollectionCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet AmphibianImage *image;
@property (strong, nonatomic) IBOutlet UILabel *title;

@end
