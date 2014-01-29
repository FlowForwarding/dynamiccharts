//
//  NCIZoomChartView.h
//  NCIChart
//
//  Created by Ira on 1/27/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import "NCISimpleChartView.h"

@interface NCIZoomChartView : NCISimpleChartView

- (NSArray *)getValsInRanges;

-(double)getScaleIndex;
-(double)getTimePeriod;
-(double)getRangesPeriod;

@property(nonatomic)double minRangeVal;
@property(nonatomic)double maxRangeVal;

@end
