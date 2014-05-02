//
//  NCIAxis.h
//  NCIChart
//
//  Created by Ira on 4/15/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCILine.h"

@class NCISimpleChartView;

@interface NCIAxis : NCILine

- (id)initWithOptions:(NSDictionary *)options;
- (void)redrawLabels:(float)length min:(double)min max:(double)max;
- (void)drawBoundary:(CGContextRef ) currentContext;

@property(nonatomic)bool vertical;
@property(nonatomic, strong)NSMutableArray *labels;
@property(nonatomic, strong)NCISimpleChartView* chart;
@property(nonatomic)bool nciAxisDecreasing;


@end
