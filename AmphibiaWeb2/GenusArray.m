//
//  GenusArray.m
//  AmphibiaWeb
//
//  Created by Mel Roderick on 6/30/12.
//  Copyright (c) 2012 Melrose Entertainment. All rights reserved.
//

#import "GenusArray.h"

@implementation GenusArray

-(id)initWithGenus:(NSString *)inputGenus
{
    self = [super init];
    if (self) {
        genus = inputGenus;
        amphibians = [[NSMutableArray alloc] init];
    }
    return self;
}
-(NSString *)getGenusName
{
    return genus;
}
-(void)addObject:(id)object
{
    [amphibians addObject:object];
}
-(id)objectAtIndex:(unsigned int)index
{
    return [amphibians objectAtIndex:index];
}
-(unsigned int)count
{
    return (unsigned int)[amphibians count];
}

-(NSMutableArray *)amphibians
{
    return amphibians;
}

@end
