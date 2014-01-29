//
//  NCILine.m
//  NCIChart
//
//  Created by Ira on 1/15/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import "NCILine.h"

@implementation NCILine

-(id)initWithWidth:(float)w color:(UIColor *)c andDashes:(NSArray *)dashes{
    self = [self init];
    if (self){
        _width = w;
        _color = c;
        _dashes = dashes;
    }
    return self;
}

@end
