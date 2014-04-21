//
//  NCIChartView.m
//  NCIChart
//
//  Created by Ira on 12/22/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import "NCIChartView.h"
#import "NCIBtmGraphView.h"
#import "NCITopGraphView.h"

@interface NCIChartView(){
    float btmChartHeigth;
    float chartsSpace;
    NSMutableDictionary *topOptions;
    NSMutableDictionary *bottomOptions;
}

@end

@implementation NCIChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        topOptions = [[NSMutableDictionary alloc] init];
        bottomOptions = [[NSMutableDictionary alloc] init];
        [self addGraps];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andOptions:(NSDictionary *)opts{
    self = [super initWithFrame:frame];
    if (self) {
        if ([opts objectForKey:nciTopGraphOptions]){
            topOptions = [[NSMutableDictionary alloc] initWithDictionary: [opts objectForKey:nciTopGraphOptions]];
        } else {
            topOptions = [[NSMutableDictionary alloc] init];
        }
        if ([opts objectForKey:nciBottomGraphOptions]){
            bottomOptions = [[NSMutableDictionary alloc] initWithDictionary: [opts objectForKey:nciBottomGraphOptions]];
        } else {
            bottomOptions = [[NSMutableDictionary alloc] init];
        }
        if ([opts objectForKey:nciBottomChartHeight]){
            btmChartHeigth = [[opts objectForKey:nciBottomChartHeight] floatValue];
        }
        [self addGraps];
    }
    return self;
}

- (void)defaultSetup{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        btmChartHeigth =  90;
        chartsSpace = 30;
    } else {
        btmChartHeigth =  50;
        chartsSpace = 10;
    }
    self.chartData = [[NSMutableArray alloc] init];
}

- (void)addGraps{
    [topOptions setObject:[NCITopGraphView class] forKey:nciGraphRenderer];
    _topChart = [[NCISimpleChartView alloc] initWithFrame:CGRectZero andOptions:topOptions];
    ((NCITopGraphView *)_topChart.graph).nciChart = self;
    _topChart.chartData = self.chartData;
    _topChart.nciHasSelection = YES;
    [bottomOptions setObject:[NCIBtmGraphView class] forKey:nciGraphRenderer];
    _btmChart = [[NCISimpleChartView alloc] initWithFrame:CGRectZero andOptions:bottomOptions];
    ((NCIBtmGraphView *)_btmChart.graph).nciChart = self;
    _btmChart.chartData = self.chartData;
    _btmChart.nciHasSelection = NO;
    _btmChart.nciHasHorizontalGrid = NO;
    [self addSubview:_topChart];
    [self addSubview:_btmChart];
}

- (void)addSubviews{

}

-(void)drawChart{
    [_topChart drawChart];
    [_btmChart drawChart];

}

- (void)setMinRangeVal:(double)minRangeVal{
    self.topChart.minRangeVal = minRangeVal;
}

- (void)setMaxRangeVal:(double)maxRangeVal{
    self.topChart.maxRangeVal = maxRangeVal;
}

- (double)maxRangeVal{
    return self.topChart.maxRangeVal;
}

- (double)minRangeVal{
    return self.topChart.minRangeVal;
}

- (void)resetChart{
    [self.chartData removeAllObjects];
}

- (void)layoutSubviews{
    _topChart.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - btmChartHeigth - chartsSpace);
    _btmChart.frame = CGRectMake(0, self.frame.size.height - btmChartHeigth, self.frame.size.width, btmChartHeigth);
}


@end
