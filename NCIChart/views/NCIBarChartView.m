//
//  NCIBarChartView.m
//  NCIChart
//
//  Created by Ira on 3/11/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import "NCIBarChartView.h"
#import "NCIBarGraphView.h"

@implementation NCIBarChartView

- (void)addSubviews{
    self.graph = [[NCIBarGraphView alloc] initWithChart:self];
    [self addSubview:self.graph];
}

@end
