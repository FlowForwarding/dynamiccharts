//
//  NCIZoomChartView.m
//  NCIChart
//
//  Created by Ira on 1/27/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import "NCIZoomChartView.h"
#import "NCIZoomGraphView.h"


@implementation NCIZoomChartView

- (void)addSubviews{
    _minRangeVal = NAN;
    _maxRangeVal = NAN;
    self.graph = [[NCIZoomGraphView alloc] initWithChart:self];
    [self addSubview:self.graph];
}


@end
