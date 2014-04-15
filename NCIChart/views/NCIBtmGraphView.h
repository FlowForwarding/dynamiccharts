//
//  NCIBtmChartView.h
//  NCIChart
//
//  Created by Ira on 12/22/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCISimpleGraphView.h"
@class NCIChartView;

@interface NCIBtmGraphView : NCISimpleGraphView

- (void)redrawRanges;
- (void)startMoveWithPoint:(CGPoint) point1 andPoint:(CGPoint) point2;
- (void)moveReverseRangesWithPoint:(CGPoint) point1 andPoint:(CGPoint) point2;

@property(nonatomic, strong) NCIChartView* nciChart;

@end
