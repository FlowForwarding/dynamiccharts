//
//  NCILine.m
//  NCIChart
//
//  Created by Ira on 1/15/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import "NCILine.h"
#import "NCIChartOptions.h"

@implementation NCILine

- (id)initWithOptions:(NSDictionary *)options{
    self = [self init];
    if (self){
        if ([options objectForKey:nciLineColor]){
            self.color = [options objectForKey:nciLineColor];
        } else {
            self.color = [UIColor blackColor];
        }
        
        if ([options objectForKey:nciLineWidth]){
            self.width = [[options objectForKey:nciLineWidth] floatValue];
        } else {
            self.width = 0.3;
        }
        
        if ([options objectForKey:nciLineDashes]){
            self.dashes = [options objectForKey:nciLineDashes];
        } else {
            self.dashes = @[ @1, @1 ];
        }
    }
    return self;
}

- (void)setUpLine:(CGContextRef) currentContext{
    if (_width)
        CGContextSetLineWidth(currentContext, _width);
    if (_color)
        [_color setStroke];
    if (_dashes && _dashes.count == 2
        && [_dashes[0] integerValue]
        && [_dashes[1] integerValue]){
        CGFloat dashes[] = { [_dashes[0] integerValue], [_dashes[1] integerValue]};
        CGContextSetLineDash(currentContext, 0.0, dashes, 2 );
    } else {
        CGContextSetLineDash(currentContext, 0, NULL, 0);
    }
    
}

@end
