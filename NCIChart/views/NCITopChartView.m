//
//  NCITopChartView.m
//  NCIChart
//
//  Created by Ira on 12/22/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import "NCITopChartView.h"
#import "NCITopGraphView.h"
#import "NCIChartView.h"

@interface NCITopChartView(){
}

@end

@implementation NCITopChartView


- (void)addSubviews{
    self.minRangeVal = NAN;
    self.maxRangeVal = NAN;
    self.graph = [[NCITopGraphView alloc] initWithChart:self];
    [self addSubview:self.graph];
}

@end
