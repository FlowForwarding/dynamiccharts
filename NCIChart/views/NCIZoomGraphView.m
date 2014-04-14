//
//  NCIZoomGraphView.m
//  NCIChart
//
//  Created by Ira on 1/27/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import "NCIZoomGraphView.h"
#import "NCIZoomGridView.h"
#import "NCIZoomChartView.h"

@interface NCIZoomGraphView(){
    UIScrollView *gridScroll;
}

@end

@implementation NCIZoomGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIPinchGestureRecognizer *croperViewGessture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(croperViewScale:)];
        [self addGestureRecognizer:croperViewGessture];
    }
    return self;
}

-(void)croperViewScale:(id)sender
{
    if (self.chart.chartData.count == 0)
        return;
    if([(UIPinchGestureRecognizer *)sender state]==UIGestureRecognizerStateBegan)
    {
        
        if ([sender numberOfTouches] == 2) {
            CGPoint point1 = [(UIPinchGestureRecognizer *)sender locationOfTouch:0 inView:self];
            CGPoint point2 = [(UIPinchGestureRecognizer *)sender locationOfTouch:1 inView:self];
            [self startMoveWithPoint:point1 andPoint:point2];
        }
    }
    if ([(UIPinchGestureRecognizer *)sender state] == UIGestureRecognizerStateChanged) {
        if ([sender numberOfTouches] == 2) {
            CGPoint point1 = [(UIPinchGestureRecognizer *)sender locationOfTouch:0 inView:self];
            CGPoint point2 = [(UIPinchGestureRecognizer *)sender locationOfTouch:1 inView:self];
            [self moveRangesWithPoint:point1 andPoint:point2];
        }
    }
    
}

static float startFingersDiff;
static float startRangesDiff;
static float startMinRangeVal;
static float startMaxRangeVal;

- (void)startMoveWithPoint:(CGPoint) point1 andPoint:(CGPoint) point2{
    startFingersDiff = point1.x - point2.x;
    startRangesDiff = ((NCIZoomChartView *)self.chart).maxRangeVal - ((NCIZoomChartView *)self.chart).minRangeVal;
    startMinRangeVal = ((NCIZoomChartView *)self.chart).minRangeVal;
    startMaxRangeVal = ((NCIZoomChartView *)self.chart).maxRangeVal;
}

- (void)moveRangesWithPoint:(CGPoint) point1 andPoint:(CGPoint) point2{
    float newFingersDiff = point1.x - point2.x;
    float newRangesDiffs = startRangesDiff * newFingersDiff/startFingersDiff;
    double oneSideShiftRange = (startRangesDiff  - newRangesDiffs)/2;
    
    double newMin = startMinRangeVal - oneSideShiftRange;
    if (newMin  < [self.chart.chartData[0][0] doubleValue]){
        newMin  = [self.chart.chartData[0][0] doubleValue];
    }
    double newMax = startMaxRangeVal + oneSideShiftRange;
    if (newMax  > [[self.chart.chartData lastObject][0] doubleValue]){
        newMax  = [[self.chart.chartData lastObject][0] doubleValue];
    }
    if (newMin >= newMax || ((newMax - newMin) < 0.000005) )
        return;
    ((NCIZoomChartView *)self.chart).minRangeVal = newMin;
    ((NCIZoomChartView *)self.chart).maxRangeVal = newMax;

    [self setNeedsLayout];

}

- (void)addSubviews{
    gridScroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [gridScroll setShowsVerticalScrollIndicator:NO];
    [self addSubview:gridScroll];
    gridScroll.delegate = self;
    self.grid = [[NCIZoomGridView alloc] initWithGraph:self];
    [gridScroll addSubview:self.grid];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.chart.chartData.count == 0)
        return;
    NCIZoomChartView *zoomChart = (NCIZoomChartView *)self.chart;
    float scaleIndex = [self getScaleIndex];
    float timePeriod = [self getXValuesGap];
    float rangesPeriod = [self getRangesPeriod];
    
    float offsetForRanges = scrollView.contentOffset.x;
    if (offsetForRanges < 0)
        offsetForRanges = 0;
    if (offsetForRanges > (scrollView.contentSize.width - scrollView.frame.size.width))
        offsetForRanges = scrollView.contentSize.width - scrollView.frame.size.width;
    
    double newMinRange = [self.chart.chartData[0][0] doubleValue] +
    timePeriod*(offsetForRanges/scrollView.frame.size.width/scaleIndex);
    zoomChart.minRangeVal = newMinRange;
    zoomChart.maxRangeVal = newMinRange + rangesPeriod;
    
    self.grid.frame = CGRectMake(gridScroll.contentOffset.x, 0, self.gridWidth, self.gridHeigth);
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    if (self.chart.chartData.count == 0)
        return;
    float scaleIndex = [self getScaleIndex];
    float contentWidth = self.gridWidth* scaleIndex;
    float timeDiff = [[self.chart.chartData lastObject][0] doubleValue] - [self.chart.chartData[0][0] doubleValue];
    if (timeDiff == 0)
        timeDiff = 1000*60*2;
    
    float stepX = contentWidth/timeDiff;
    gridScroll.frame = CGRectMake(self.chart.nciGridLeftMargin, 0, self.gridWidth, self.gridHeigth);
    gridScroll.contentSize = CGSizeMake(contentWidth, self.gridHeigth);
    
    if (((NCIZoomChartView *)self.chart).minRangeVal != ((NCIZoomChartView *)self.chart).minRangeVal){
        ((NCIZoomChartView *)self.chart).minRangeVal = [self.chart.chartData[0][0] doubleValue];
        ((NCIZoomChartView *)self.chart).maxRangeVal = [[self.chart.chartData lastObject][0] doubleValue];
    }
    double timeOffest = ((NCIZoomChartView *)self.chart).minRangeVal  -  [self.chart.chartData[0][0] doubleValue];
    if (timeOffest < 0 || timeOffest != timeOffest)
        timeOffest = 0;
    gridScroll.contentOffset = CGPointMake(timeOffest * stepX, 0);
    self.grid.frame = CGRectMake(timeOffest * stepX, 0, self.gridWidth, self.gridHeigth);
    [self.chart layoutSelectedPoint];
}

- (NSArray *)getValsInRanges{
    float minYVal = MAXFLOAT;
    float maxYVal = -MAXFLOAT;
    long firstDataIndex = self.chart.chartData.count;
    long lastChartIndex = 0;
    long index;
    for(index = 1; index < self.chart.chartData.count; index++){
        NSArray *point = self.chart.chartData[index];
        
        for (int serisNum = 0; serisNum < ((NSArray *)point[1]).count; serisNum++){
            if ([point[1][serisNum] isKindOfClass:[NSNull class]]){
                continue;
            }
            NSArray * prevPoint = self.chart.chartData[index - 1];
            if ([prevPoint[1][serisNum] isKindOfClass:[NSNull class]]){
                prevPoint = @[prevPoint[serisNum], point[1]];
            }
            
            NSArray * nextPoint;
            if (self.chart.chartData.count != (index + 1)){
                nextPoint = self.chart.chartData[index + 1];
                if ([nextPoint[1][serisNum] isKindOfClass:[NSNull class]]){
                    nextPoint = @[nextPoint[0], point[1]];
                }
            } else {
                nextPoint = point;
            }
            
            float curMax = [prevPoint[1][serisNum] floatValue];
            float curMin = [prevPoint[1][serisNum] floatValue];
            if ([point[1][serisNum] floatValue] > [prevPoint[1][serisNum] floatValue]){
                curMax = [point[1][serisNum] floatValue];
            } else {
                curMin= [point[1][serisNum] floatValue];
            }
            if ( curMax < [nextPoint[1][serisNum] floatValue]){
                curMax = [nextPoint[1][serisNum] floatValue];
            }
            if ( curMin > [nextPoint[1][serisNum] floatValue]){
                curMin = [nextPoint[1][serisNum] floatValue];
            }
            
            if ( ((NCIZoomChartView *)self.chart).minRangeVal <= [point[0] doubleValue] &&
                ( minYVal == MAXFLOAT || ((NCIZoomChartView *)self.chart).maxRangeVal  >= [point[0] doubleValue])){
                
                if (firstDataIndex > (index - 1)){
                    firstDataIndex = (index - 1);
                }
                if (lastChartIndex < (index + 1)){
                    lastChartIndex = (index + 1);
                }
                if (curMin < minYVal)
                    minYVal = curMin;
                if (curMax > maxYVal)
                    maxYVal = curMax;
            }
        }
    }
    
    if (minYVal == MAXFLOAT)
        return @[@(0), @(1), @(0), @(self.chart.chartData.count)];
    
    float diff = maxYVal - minYVal;
    if (diff == 0){
        maxYVal = maxYVal + 1;
        minYVal = minYVal - 1;
    } else {
        maxYVal = maxYVal + diff*self.chart.topBottomGridSpace/100;
        minYVal = minYVal - diff*self.chart.topBottomGridSpace/100;
    }
    
    if (lastChartIndex < self.chart.chartData.count)
        lastChartIndex = lastChartIndex + 1;
    
    return @[@(minYVal),
             @(maxYVal),
             @(firstDataIndex),
             @(lastChartIndex)];
}

- (double)getScaleIndex{
    if ( ((NCIZoomChartView *)self.chart).minRangeVal !=  ((NCIZoomChartView *)self.chart).minRangeVal || ((NCIZoomChartView *)self.chart).maxRangeVal !=  ((NCIZoomChartView *)self.chart).maxRangeVal)
        return 1;
    double rangeDiff = [self getRangesPeriod];
    if (rangeDiff == 0){
        return  1;
    } else {
        return [self getXValuesGap]/rangeDiff;
    }
}

-(double)getXValuesGap{
    if (self.chart.chartData.count == 0)
        return 0;
    return [[self.chart.chartData lastObject][0] doubleValue] - [self.chart.chartData[0][0] doubleValue];
}

-(double)getRangesPeriod{
    return  ((NCIZoomChartView *)self.chart).maxRangeVal -  ((NCIZoomChartView *)self.chart).minRangeVal;
}

- (void)redrawXLabels{
    float scaleIndex = [self getScaleIndex];
    float xLabelsDistance = self.chart.nciXLabelsDistance;
    [self formatDateForDistance:xLabelsDistance/scaleIndex];
    
    float shift = gridScroll.contentOffset.x - xLabelsDistance*((int)gridScroll.contentOffset.x / (int)xLabelsDistance);
    for(int i = 0; i<= self.gridWidth/xLabelsDistance + 1; i++){
        float xVal = self.chart.nciGridLeftMargin + xLabelsDistance *i - shift;
        if ((xVal - self.chart.nciGridLeftMargin) >= 0 && (xVal < self.frame.size.width) ){
            UILabel *label = [[UILabel alloc] initWithFrame:
                              CGRectMake(xVal - xLabelsDistance/2,
                                         self.frame.size.height - self.chart.nciGridBottomMargin , xLabelsDistance ,
                                         self.chart.nciGridBottomMargin)];
            double curVal = [self getArgumentByX: xVal -  self.chart.nciGridLeftMargin];
            [self makeUpXLabel:label val:curVal];
        }
    }
}

- (double)getArgumentByX:(float) pointX{
    float scaleIndex = [self getScaleIndex];
    return self.minXVal + (gridScroll.contentOffset.x + pointX)/scaleIndex/self.xStep;
}

- (float)getXByArgument:(double) arg{
    float scaleIndex = [self getScaleIndex];
    return (arg - self.minXVal)*self.xStep * scaleIndex - gridScroll.contentOffset.x;
}

- (void)detectRanges{
    NSArray *yVals = [self getValsInRanges];
    self.minYVal = [yVals[0] floatValue];
    self.maxYVal = [yVals[1] floatValue];
    self.yStep = self.gridHeigth/(self.maxYVal - self.minYVal);
}

@end
