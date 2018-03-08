
//
//  AmphibianCell.m
//  AmphibiaWeb
//
//  Created by Mel Roderick on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AmphibianCell.h"
#import "ViewController.h"

#import "Table.h"

@implementation AmphibianCell

@synthesize imageView;
@synthesize button;
@synthesize name;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            //initialize imageView
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image.png"]];
            [self addSubview:imageView];
            imageView.frame = CGRectMake(550, 2, 75, 75);
            [imageView setHidden:YES];
            [imageView setAlpha:0.75];
            
            //initialize button
            button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setImage:[UIImage imageNamed:@"sound.gif"] forState:UIControlStateNormal];
            [self addSubview:button];
            button.frame = CGRectMake(635, 1, 80, 80);
            [button setHidden:YES];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            //initialize name
            name = [[UILabel alloc] initWithFrame:CGRectMake(100, 1, 500, 80)];
            [name setBackgroundColor:[UIColor clearColor]];
            [self addSubview:name];
            [name setFont:[UIFont italicSystemFontOfSize:34]];
        }
        else
        {
            //initialize imageView
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image.png"]];
            [self addSubview:imageView];
            imageView.frame = CGRectMake(230, 2, 35, 35);
            [imageView setHidden:YES];
            [imageView setAlpha:0.75];
            
            //initialize button
            button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setImage:[UIImage imageNamed:@"sound.gif"] forState:UIControlStateNormal];
            [self addSubview:button];
            button.frame = CGRectMake(268, 1, 40, 40);
            [button setHidden:YES];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            //initialize name
            name = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, 295, 40)];
            [name setBackgroundColor:[UIColor clearColor]];
            [self addSubview:name];
            [name setFont:[UIFont italicSystemFontOfSize:18]];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setImageDisplay:(BOOL)display
{
    imageView.hidden = !display;
    [self setNeedsDisplay];
}

-(void)setButtonSound:(NSURL *)sound
{
    soundURL = sound;
    if(sound != NULL)
    {
        [button setHidden:NO];
        [self setNeedsDisplay];
    }
}

-(void)giveSection:(int)inputSection andRow:(int)inputRow
{
    section = inputSection;
    row = inputRow;
}

-(void)buttonPressed:(id)sender
{
    [delegate cellSoundButtonPressed:self];
}

-(CGPoint)getButtonCenter
{
    return button.center;
}

-(void)setNameText:(NSString *)text
{
    name.text = text;
}

-(void)setDelegate:(Table *)table
{
    delegate = table;
}

-(void)dealloc
{
    [imageView removeFromSuperview];
    [button removeFromSuperview];
    [name removeFromSuperview];
}

@end
