//
//  CollectionViewController.h
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 6/11/13.
//  Copyright (c) 2013 Mel Roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GenusArray.h"
#import "AmphibianCollectionCell.h"

@interface CollectionViewController : UICollectionViewController<UICollectionViewDataSource, UICollectionViewDelegate, AmphibianCollectionCellDelegate, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *data;
    
    NSMutableDictionary *images;
    
    NSString *title;
    
    BOOL genus;
    
    NSString *loc;
    
    float size;
}

-(void)passGenera:(NSMutableArray *)genera andTitle:(NSString *)text andSize:(float)inSize andLoc:(NSString *)location;
-(void)passSpecies:(NSMutableArray *)species andTitle:(NSString *)text andSize:(float)inSize;

-(void)updateForSize:(float)inSize;

@end
