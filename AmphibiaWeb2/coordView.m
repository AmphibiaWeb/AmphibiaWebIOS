//
//  coordView.m
//  AmphibiaWeb
//
//  Created by Mel Roderick on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "coordView.h"
#import "ViewController.h"

@implementation coordView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self]; // finding x-y point
    [delegate coordViewTouchedAtPoint:pt]; // sending to delegate
}

@end
