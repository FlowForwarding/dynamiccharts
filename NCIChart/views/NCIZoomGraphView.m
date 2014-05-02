//
//  NCIZoomGraphView.m
//  NCIChart
//
//  Created by Ira on 1/27/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import "NCIZoomGraphView.h"
#import "NCISimpleGridView.h"

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
    startRangesDiff = self.chart.maxRangeVal - self.chart.minRangeVal;
    startMinRangeVal = self.chart.minRangeVal;
    startMaxRangeVal = self.chart.maxRangeVal;
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
    self.chart.minRangeVal = newMin;
    self.chart.maxRangeVal = newMax;

    [self setNeedsLayout];

}

- (void)addSubviews{
    gridScroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [gridScroll setShowsVerticalScrollIndicator:NO];
    [self addSubview:gridScroll];
    gridScroll.delegate = self;
    self.grid = [[NCISimpleGridView alloc] initWithGraph:self];
    [gridScroll addSubview:self.grid];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.chart.chartData.count == 0)
        return;
    float rangesPeriod = [self getRangesPeriod];
    
    float offsetForRanges = scrollView.contentOffset.x;
    if (offsetForRanges < 0)
        offsetForRanges = 0;
    if (offsetForRanges > (scrollView.contentSize.width - scrollView.frame.size.width))
        offsetForRanges = scrollView.contentSize.width - scrollView.frame.size.width;
    
    double newMinRange = [self getArgumentByX:0];
    if (self.chart.xAxis.nciAxisDecreasing){
        self.chart.maxRangeVal = newMinRange;
        self.chart.minRangeVal = newMinRange - rangesPeriod;
    } else {
        self.chart.minRangeVal = newMinRange;
        self.chart.maxRangeVal = newMinRange + rangesPeriod;
    }
    
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
    gridScroll.frame = CGRectMake(0, 0, self.gridWidth, self.gridHeigth);
    gridScroll.contentSize = CGSizeMake(contentWidth, self.gridHeigth);
    
    if (self.chart.minRangeVal != self.chart.minRangeVal){
        self.chart.minRangeVal = [self.chart.chartData[0][0] doubleValue];
        self.chart.maxRangeVal = [[self.chart.chartData lastObject][0] doubleValue];
    }
    
    double timeOffest;
    if (self.chart.xAxis.nciAxisDecreasing){
        timeOffest =  [[self.chart.chartData lastObject] [0] doubleValue] - self.chart.maxRangeVal;
    } else {
        timeOffest = self.chart.minRangeVal  -  [self.chart.chartData[0][0] doubleValue];
    }

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
            
            if ( self.chart.minRangeVal <= [point[0] doubleValue] &&
                ( minYVal == MAXFLOAT || self.chart.maxRangeVal  >= [point[0] doubleValue])){
                
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
    if ( self.chart.minRangeVal !=  self.chart.minRangeVal || self.chart.maxRangeVal !=  self.chart.maxRangeVal)
        return 1;
    double rangeDiff = [self getRangesPeriod];
    if (rangeDiff == 0){
        return  1;
    } else {
        return [self getXValuesGap]/rangeDiff;
    }
}

- (double)getXValuesGap{
    if (self.chart.chartData.count == 0)
        return 0;
    return [[self.chart.chartData lastObject][0] doubleValue] - [self.chart.chartData[0][0] doubleValue];
}

- (double)getRangesPeriod{
    return  self.chart.maxRangeVal - self.chart.minRangeVal;
}

- (double)getArgumentByX:(float) pointX{
    float scaleIndex = [self getScaleIndex];
    
    if (self.chart.xAxis.nciAxisDecreasing){
        return self.maxXVal - (gridScroll.contentOffset.x + pointX)/scaleIndex/self.xStep;
    } else {
        return self.minXVal + (gridScroll.contentOffset.x + pointX)/scaleIndex/self.xStep;
    }
}

- (float)getXByArgument:(double) arg{
    float scaleIndex = [self getScaleIndex];
    return [super getXByArgument:arg]* scaleIndex - gridScroll.contentOffset.x;
}

- (void)detectRanges{
    NSArray *yVals = [self getValsInRanges];
    self.minYVal = [yVals[0] floatValue];
    self.maxYVal = [yVals[1] floatValue];
    self.yStep = self.gridHeigth/(self.maxYVal - self.minYVal);
}

- (NSArray *)getFirstLast{
    NSArray *values = [self getValsInRanges];
    return @[values[2], values[3]];
}


@end
