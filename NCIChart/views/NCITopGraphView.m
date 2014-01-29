//
//  NCITopGraphView.m
//  NCIChart
//
//  Created by Ira on 12/22/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import "NCITopGraphView.h"
#import "NCIZoomGridView.h"
#import "NCIBtmChartView.h"
#import "NCIChartView.h"
#import "NCITopChartView.h"

@interface NCITopGraphView(){
    UIScrollView *gridScroll;
}
@end

@implementation NCITopGraphView


-(void)croperViewScale:(id)sender
{
    if (self.chart.chartData.count == 0)
        return;
    if([(UIPinchGestureRecognizer *)sender state]==UIGestureRecognizerStateBegan)
    {
        
        if ([sender numberOfTouches] == 2) {
            CGPoint point1 = [(UIPinchGestureRecognizer *)sender locationOfTouch:0 inView:self];
            CGPoint point2 = [(UIPinchGestureRecognizer *)sender locationOfTouch:1 inView:self];
            [((NCITopChartView *)self.chart).nciChart.btmChart startMoveWithPoint:point1 andPoint:point2];
        }
    }
    if ([(UIPinchGestureRecognizer *)sender state] == UIGestureRecognizerStateChanged) {
        if ([sender numberOfTouches] == 2) {
            CGPoint point1 = [(UIPinchGestureRecognizer *)sender locationOfTouch:0 inView:self];
            CGPoint point2 = [(UIPinchGestureRecognizer *)sender locationOfTouch:1 inView:self];
            [((NCITopChartView *)self.chart).nciChart.btmChart moveReverseRangesWithPoint:point1 andPoint:point2];
        }
    }
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    [((NCITopChartView *)self.chart).nciChart.btmChart redrawRanges];
}




@end
