//
//  Amphibian.m
//  AmphibiaWeb
//
//  Created by Mel Roderick on 7/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Amphibian.h"

@implementation Amphibian

- (id)initWithName:(NSString *)inName withPicture:(NSString *)picNUM withSound:(NSString *)soundURL
{
    self = [super init];
    if (self) {
        name = [[NSString alloc] initWithString:inName];
        if(picNUM != NULL)
        {
            picture = [[NSString alloc] initWithString:picNUM];
        }
        if(soundURL != NULL)
        {
            // converting http to https Chenyu March 8 2019
            if ([soundURL hasPrefix:@"http:"]){
                soundURL = [soundURL stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
            sound = [[NSURL alloc] initWithString:soundURL];
            
            }else{
                sound = [[NSURL alloc] initWithString:soundURL];
            }
        }
    }
    return self;
}

-(NSString *)getName
{
    return name;
}

-(NSString *)getPictureURL
{
    return picture;
}

-(NSURL *)getSoundURL
{
    return sound;
}


@end
