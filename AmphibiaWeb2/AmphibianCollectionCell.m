//
//  AmphibianCollectionCell.m
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 6/11/13.
//  Copyright (c) 2013 Mel Roderick. All rights reserved.
//

#import "AmphibianCollectionCell.h"
#import "CustomCellBackground.h"

@implementation AmphibianCollectionCell

@synthesize delegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // change to our custom selected background view
        CustomCellBackground *backgroundView = [[CustomCellBackground alloc] initWithFrame:CGRectZero];
        backgroundView.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = backgroundView;
    }
    return self;
}

-(void)prepareForReuse
{
    [self.image clear];
    
    [super prepareForReuse];
}

-(void)imageLoaded:(NSData *)imageData andID:(NSString *)identification
{
    [delegate imageLoaded:imageData andID:identification];
}

@end
