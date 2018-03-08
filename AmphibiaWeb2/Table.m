//
//  Table.m
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/3/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import "Table.h"

#import "Amphibian.h"

#import "SpeciesAccount.h"

@interface Table ()

@end

@implementation Table

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:21]];
    [titleLabel setShadowColor:[UIColor blackColor]];
    [titleLabel setShadowOffset:CGSizeMake(0, -0.8)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:title];
    self.navigationItem.titleView = titleLabel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [amphibianData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AmphibianCell *cell = [[AmphibianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    
    [cell setDelegate:self];
    
    [cell setNameText:[NSString stringWithFormat:@"%@",[[amphibianData objectAtIndex:indexPath.row] getName]]];
    if([[amphibianData objectAtIndex:indexPath.row] getPictureURL] != NULL)
    {
        [cell setImageDisplay:YES];
    }
    [cell setButtonSound:[[amphibianData objectAtIndex:indexPath.row] getSoundURL]];
    [cell giveSection:0 andRow:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 85;
    }
    else
    {
        return 45;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    
    [table deselectRowAtIndexPath:index animated:YES];
    
    [self performSegueWithIdentifier:@"toSpecies" sender:self];
}

-(void)passData:(NSArray *)data
{
    //amphibia were found, now show the table
    
    amphibianData = [[NSArray alloc] initWithArray:data];
    
    [table reloadData];
    [activity stopAnimating];
}

-(void)passTitle:(NSString *)string
{
    title = string;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [(SpeciesAccount *)[segue destinationViewController] passAmphibian:[amphibianData objectAtIndex:index.row] andImage:NULL];
}

- (void)cellSoundButtonPressed:(id)sender
{
    // Sound button was pressed
    // load and play
    
    int row = [table indexPathForCell:sender].row;
    
    if(soundPlayingRow == row) // checks if selected sound was already loaded
    {
        //if so, stop if playing
        if(amphibianSound.playing)
        {
            [amphibianSound stop];
        }
        
        //or, restart and play if stopped
        else
        {
            amphibianSound.currentTime = 0;
            [amphibianSound play];
        }
    }
    else
    {
        // if not loaded, load it
        
        // if loaded, but not from the same amphibian, release it
        if(amphibianSound != NULL)
        {
            amphibianSound = NULL;
        }
        
        //set row and section of soon to be saved sound
        soundPlayingRow = row;
        
        // load sound
        NSURL *tempURL = [[amphibianData objectAtIndex:row] getSoundURL];
        
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:tempURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        soundURLConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        if (soundURLConnection) {
            // Create the NSMutableData to hold the received data.
            // receivedData is an instance variable declared elsewhere.
            soundData = [NSMutableData data];
            
            [soundActivity startAnimating];
            tempCellIndex = [table indexPathForCell:sender];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [soundActivity setCenter:CGPointMake([(AmphibianCell *)[table cellForRowAtIndexPath:tempCellIndex] getButtonCenter].x, -[self.view convertPoint:[(AmphibianCell *)[table cellForRowAtIndexPath:tempCellIndex] getButtonCenter] toView:[table cellForRowAtIndexPath:tempCellIndex]].y + 83)];
            }
            else
            {
                [soundActivity setCenter:CGPointMake([(AmphibianCell *)[table cellForRowAtIndexPath:tempCellIndex] getButtonCenter].x, -[self.view convertPoint:[(AmphibianCell *)[table cellForRowAtIndexPath:tempCellIndex] getButtonCenter] toView:[table cellForRowAtIndexPath:tempCellIndex]].y + 42)];
            }
            
            recievingSound = YES;
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        } else {
            // Inform the user that the connection failed.
        }
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [soundData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (recievingSound) {
        amphibianSound = [[AVAudioPlayer alloc] initWithData:soundData error:NULL];
        
        [soundActivity stopAnimating];
        
        recievingSound = NO;
        
        //play sound
        [amphibianSound play];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(tempCellIndex != NULL)
    {
        if([table cellForRowAtIndexPath:tempCellIndex] != NULL)
        {
            if(soundActivity.hidden)
            {
                [soundActivity setHidden:NO];
            }
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [soundActivity setCenter:CGPointMake([(AmphibianCell *)[table cellForRowAtIndexPath:tempCellIndex] getButtonCenter].x, -[self.view convertPoint:[(AmphibianCell *)[table cellForRowAtIndexPath:tempCellIndex] getButtonCenter] toView:[table cellForRowAtIndexPath:tempCellIndex]].y + 83)];
            }
            else
            {
                [soundActivity setCenter:CGPointMake([(AmphibianCell *)[table cellForRowAtIndexPath:tempCellIndex] getButtonCenter].x, -[self.view convertPoint:[(AmphibianCell *)[table cellForRowAtIndexPath:tempCellIndex] getButtonCenter] toView:[table cellForRowAtIndexPath:tempCellIndex]].y + 42)];
            }
        }
        else {
            [soundActivity setHidden:YES];
        }
    }
}

@end
