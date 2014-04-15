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

+ (void)setUpLine:(CGContextRef) currentContext line:(NCILine*)line{
    CGContextSetLineWidth(currentContext, 0.3);
    [[UIColor blackColor] setStroke];
    CGFloat dashes[] = { 1, 1 };
    CGContextSetLineDash(currentContext, 0.0,  dashes , 2 );
    if (line){
        if (line.width)
            CGContextSetLineWidth(currentContext, line.width);
        if (line.color)
            [line.color setStroke];
        if (line.dashes && line.dashes.count == 2
            && [line.dashes[0] integerValue]
            && [line.dashes[1] integerValue]){
            CGFloat dashes[] = { [line.dashes[0] integerValue], [line.dashes[1] integerValue]};
            CGContextSetLineDash(currentContext, 0.0, dashes, 2 );
        } else {
            CGContextSetLineDash(currentContext, 0, NULL, 0);
        }
    }
}

@end
