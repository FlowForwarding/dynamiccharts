//
//  NCISimpleGraphView.h
//  NCIChart
//
//  Created by Ira on 12/20/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCISimpleChartView.h"

@class NCISimpleGridView;

@interface NCISimpleGraphView : UIView

@property(nonatomic, strong) NCISimpleGridView *grid;
@property(nonatomic, strong) NCISimpleChartView *chart;

@property(nonatomic, strong) NSMutableArray *yAxisLabels;
@property(nonatomic, strong) NSMutableArray *xAxisLabels;

@property(nonatomic) float gridHeigth;
@property(nonatomic) float gridWidth;

@property(nonatomic) float yStep;
@property(nonatomic) float xStep;
@property(nonatomic) float minYVal;
@property(nonatomic) float maxYVal;
@property(nonatomic) double minXVal;
@property(nonatomic) double maxXVal;

@property(nonatomic) float yLabelShift;

@property(nonatomic, strong) NSDateFormatter *dateFormatter;

- (id)initWithChart: (NCISimpleChartView *)chartHolder;
- (void)addSubviews;

- (double)getArgumentByX:(float) pointX;
- (CGPoint)pointByValueInGrid:(NSArray *)data;
- (float)getXByArgument:(double) arg;
- (float )getValByY:(float) pointY;

//internal
- (void)formatDateForDistance:(double) distance;
- (void)makeUpXLabel:(UILabel *)label val:(double) curVal;

@end
