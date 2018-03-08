//
//  GenusArray.h
//  AmphibiaWeb
//
//  Created by Mel Roderick on 6/30/12.
//  Copyright (c) 2012 Melrose Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenusArray : NSObject
{
    NSString *genus;
    
    NSMutableArray *amphibians;
}

-(id)initWithGenus:(NSString *)inputGenus;
-(NSString *)getGenusName;
-(void)addObject:(id)object;
-(id)objectAtIndex:(unsigned int)index;
-(unsigned int)count;
-(NSMutableArray *)amphibians;

@end
