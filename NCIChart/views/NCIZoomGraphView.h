//
//  NCIZoomGraphView.h
//  NCIChart
//
//  Created by Ira on 1/27/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import "NCISimpleGraphView.h"

@interface NCIZoomGraphView : NCISimpleGraphView<UIScrollViewDelegate>

- (NSArray *)getValsInRanges;
-(double)getScaleIndex;
-(double)getXValuesGap;
-(double)getRangesPeriod;

@end
