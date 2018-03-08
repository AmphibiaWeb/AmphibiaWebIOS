//
//  AmphibianCell.h
//  AmphibiaWeb
//
//  Created by Mel Roderick on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  This class is an extension of UITableViewCell made to
//  a sound button, a picture icon and a label which is in
//  front of the button and icon.

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class Table;

@interface AmphibianCell : UITableViewCell
{
    Table *delegate;
    
    UIImageView *imageView; // picture icon
    UIButton *button; // sound button
    UILabel *name; // species name label (I used a seperate one to allow it to be in front)
    NSURL *soundURL; // stores the sound url to pass it to the AppDelegate
    int section; // section where it is found
    int row; // row where it is found
    // These last two are needed for the AppDelegate, but were not stored in super class
}

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIButton *button;
@property (nonatomic) UILabel *name;

-(void)giveSection:(int)inputSection andRow:(int)inputRow; // input section and row
-(void)setImageDisplay:(BOOL)display; // tell self to display or hide the picture icon
-(void)setButtonSound:(NSURL *)sound; // tell self to display or hide the sound button; also input soundURL
-(void)setNameText:(NSString *)text; // input text for label
-(CGPoint)getButtonCenter;
-(void)setDelegate:(Table *)table;

@end
