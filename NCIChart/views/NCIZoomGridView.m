//
//  NCIZoomGridView.m
//  NCIChart
//
//  Created by Ira on 1/27/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import "NCIZoomGridView.h"
#import "NCIZoomChartView.h"

@implementation NCIZoomGridView

- (NSArray *)getFirstLast{
    NSArray *values = [((NCIZoomChartView *)self.graph.chart) getValsInRanges];
    return @[values[2], values[3]];
}


@end
