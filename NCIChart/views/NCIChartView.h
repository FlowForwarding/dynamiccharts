//
//  NCIChartView.h
//  NCIChart
//
//  Created by Ira on 12/22/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCISimpleChartView.h"
#import "NCITopChartView.h"
#import "NCIBtmChartView.h"

@interface NCIChartView : NCISimpleChartView

@property(nonatomic, strong) NCITopChartView *topChart;
@property(nonatomic, strong) NCIBtmChartView *btmChart;
@property(nonatomic)double minRangeVal;
@property(nonatomic)double maxRangeVal;

//callbacks
@property (nonatomic, copy) void (^rangesMoved)(void);

-(id)initWithFrame:(CGRect)frame andOptions:(NSDictionary *)opts;

-(void)resetChart;

@end
