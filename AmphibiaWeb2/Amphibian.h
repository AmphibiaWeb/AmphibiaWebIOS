//
//  Amphibian.h
//  AmphibiaWeb
//
//  Created by Mel Roderick on 7/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  This class stores the data retrieved at the species lookup for each amphibian


#import <Foundation/Foundation.h>

@interface Amphibian : NSObject
{
    NSString *name; // amphibian genus and species name
    NSString *picture; // 4x4 digit code to retrieve the calphotos picture
    NSURL *sound; // url of the sound file
}

- (id)initWithName:(NSString *)inName withPicture:(NSString *)picNUM withSound:(NSString *)soundURL; // initializer
-(NSString *)getName; // getter for name
-(NSString *)getPictureURL; // getter for picture
-(NSURL *)getSoundURL; // getter for sound

@end
