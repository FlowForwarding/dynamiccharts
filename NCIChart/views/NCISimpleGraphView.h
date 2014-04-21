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

@property(nonatomic) float gridHeigth;
@property(nonatomic) float gridWidth;

@property(nonatomic) float yStep;
@property(nonatomic) float minYVal;
@property(nonatomic) float maxYVal;
@property(nonatomic) double minXVal;
@property(nonatomic) double maxXVal;
@property(nonatomic) float xStep;


- (id)initWithChart: (NCISimpleChartView *)chartHolder;
- (void)addSubviews;

- (double)getArgumentByX:(float) pointX;
- (float )getValByY:(float) pointY;
- (CGPoint)pointByValueInGrid:(NSArray *)data;
- (float)getXByArgument:(double) arg;
- (NSArray *)getFirstLast;


@end
