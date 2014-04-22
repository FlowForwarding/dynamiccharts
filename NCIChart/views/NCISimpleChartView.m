//
//  NCISimpleChartView.m
//  NCIChart
//
//  Created by Ira on 12/20/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import "NCISimpleChartView.h"
#import "NCISimpleGridView.h"
#import "NCIZoomGraphView.h"

@interface NCISimpleChartView(){
    NSDateFormatter* dateFormatter;
    double selectedPointArgument;
    NSMutableArray *selectedPoints;
    UITapGestureRecognizer *gridTapped;
}

@end

@implementation NCISimpleChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:(CGRect)frame];
    if (self) {
        [self defaultSetup];
        [self addSubviews];
    }
    return self;
}

- (void)defaultSetup{
    _minRangeVal = NAN;
    _maxRangeVal = NAN;
    gridTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gridTapped:)];
    gridTapped.numberOfTapsRequired = 1;
    
    _nciGridTopMargin = 50;
    _nciGridRightMargin = 30;
    _nciHasHorizontalGrid = YES;
    _nciIsFill = [[NSMutableArray alloc] init];
    _nciIsSmooth = [[NSMutableArray alloc] init];
    _topBottomGridSpace = 10;
    _nciGridLeftMargin = 50;
    _nciLineWidths = @[@0.3];
    _nciLineColors = [NSMutableArray arrayWithArray: @[[UIColor blueColor], [UIColor greenColor], [UIColor purpleColor]]];
    _nciSelPointColors = [NSMutableArray arrayWithArray: @[[UIColor blueColor], [UIColor greenColor], [UIColor purpleColor]]];
    selectedPointArgument = NAN;
    
    self.nciHasSelection = YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        _nciSelPointSizes = @[@8];
        _nciGridBottomMargin = 40;
    } else {
        _nciSelPointSizes = @[@4];
        _nciGridBottomMargin = 20;
    }
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MMM-dd HH:mm:ss"];
    self.backgroundColor = [UIColor clearColor];
    self.chartData = [[NSMutableArray alloc] init];
}

- (id)initWithFrame:(CGRect)frame andOptions:(NSDictionary *)opts{
    self = [super initWithFrame:frame];
    if (self){
        [self defaultSetup];
        
        for (NSString* key in @[nciLineColors,
                                nciGridColor, nciIsFill, nciIsSmooth,
                                nciLeftRangeImageName, nciRightRangeImageName,
                                nciLineWidths, nciSelPointColors, nciSelPointSizes, nciSelPointImages,
                                nciSelPointTextRenderer,
                                nciTapGridAction]){
            if ([opts objectForKey:key]){
                id object = [opts objectForKey:key];
                if ([object isKindOfClass:[NSArray class]]){
                    [self setValue:[NSMutableArray arrayWithArray:object] forKey:key];
                } else {
                    [self setValue:object forKey:key];
                }
            }
        }
        
        _xAxis = [[NCIAxis alloc] initWithOptions:[opts objectForKey:nciXAxis]];
        _xAxis.chart = self;
        _yAxis = [[NCIAxis alloc] initWithOptions:[opts objectForKey:nciYAxis]];
        _yAxis.vertical = @YES;
        _yAxis.chart = self;
        _nciGridVertical = [[NCILine alloc] initWithOptions:[opts objectForKey:nciGridVertical]];
        _nciGridHorizontal = [[NCILine alloc]  initWithOptions:[opts objectForKey:nciGridHorizontal]];
        
        if ([opts objectForKey:nciGraphRenderer]){
            Class rendererClass = (Class)[opts objectForKey: nciGraphRenderer];
            self.graph = [[rendererClass alloc] initWithChart:self];
            self.graph.chart = self;
        }
    
        if ([opts objectForKey:nciGridLeftMargin])
            _nciGridLeftMargin = [[opts objectForKey:nciGridLeftMargin] floatValue];
        if ([opts objectForKey:nciGridRightMargin])
            _nciGridRightMargin = [[opts objectForKey:nciGridRightMargin] floatValue];
        if ([opts objectForKey:nciGridBottomMargin]){
            _nciGridBottomMargin = [[opts objectForKey:nciGridBottomMargin] floatValue];
        }
        
        if ([opts objectForKey:nciUseDateFormatter]){
            _nciUseDateFormatter = [[opts objectForKey:nciUseDateFormatter] boolValue];
        } else {
            _nciUseDateFormatter = NO;
        }
        if ([opts objectForKey:nciShowPoints]){
            _nciShowPoints = [[opts objectForKey:nciShowPoints] boolValue];
        } else {
            _nciShowPoints = NO;
        }
        
        if ([opts objectForKey:nciHasHorizontalGrid]){
            self.nciHasHorizontalGrid = [[opts objectForKey:nciHasHorizontalGrid] boolValue];
        }

        [self addSubviews];
        //order of 2 next opts is important
        if ([opts objectForKey:nciHasSelection]){
            self.nciHasSelection = [[opts objectForKey:nciHasSelection] boolValue];
        }
        if ([opts objectForKey:nciGridTopMargin]){
            _nciGridTopMargin = [[opts objectForKey:nciGridTopMargin] floatValue];
        }
    }
    return self;
}

- (void)addSubviews{
    if (!self.graph ){
        self.graph = [[NCISimpleGraphView alloc] initWithChart:self];
    }
    [self addSubview:_graph];
    [self setupSelection];
}

-(UIView *)createSelPoint:(int) num{
    UIView *selectedPoint;
    float curSize = [_nciSelPointSizes[0] floatValue];
    if (num <[_nciSelPointSizes count] && ![_nciSelPointSizes[num] isKindOfClass:[[NSNull null] class]]){
            curSize = [_nciSelPointSizes[num] floatValue];
    }
    if (_nciSelPointImages && _nciSelPointImages.count >= (num+1) && ![_nciSelPointImages[num] isKindOfClass:[NSNull class]]){
        selectedPoint = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, curSize, curSize)];
        ((UIImageView *)selectedPoint).image = [UIImage imageNamed:_nciSelPointImages[num]];
    } else {
        selectedPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, curSize, curSize)];
        selectedPoint.layer.cornerRadius = curSize/2;
    }
    selectedPoint.hidden = YES;
    [self addSubview:selectedPoint];
    [selectedPoints addObject:selectedPoint];
    return selectedPoint;
}

- (void)setupSelection{
    if (!_nciHasSelection)
        return;
    if (_selectedLabel || !self.graph.grid)
        return;
    _selectedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _selectedLabel.textAlignment = NSTextAlignmentRight;
    _selectedLabel.numberOfLines = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        _selectedLabel.font = [UIFont systemFontOfSize:14];
    } else {
        _selectedLabel.font = [UIFont systemFontOfSize:10];
    }
    [self addSubview:_selectedLabel];
    [self.graph.grid addGestureRecognizer:gridTapped];
    selectedPoints = [[NSMutableArray alloc] init];
}

- (void)setNciHasSelection:(bool)hasSelection{
    _nciHasSelection = hasSelection;
    if (hasSelection){
        if (_nciGridTopMargin == 0)
            _nciGridTopMargin = 20;
        _selectedLabel.hidden = NO;
        [self.graph.grid addGestureRecognizer:gridTapped];
        [self setupSelection];
    } else {
        _nciGridTopMargin = 0;
        _selectedLabel.hidden = YES;
        [self.graph.grid removeGestureRecognizer: gridTapped];
    }
}

- (void)simulateTapGrid:(double) xPos{
    selectedPointArgument = [self.graph getArgumentByX:xPos];
    [self layoutSelectedPoint];
}

- (void)gridTapped:(UITapGestureRecognizer *)recognizer{
    CGPoint location = [recognizer locationInView:self.graph.grid];
    selectedPointArgument = [self.graph getArgumentByX:location.x];
    if (self.nciTapGridAction){
        self.nciTapGridAction([self.graph getArgumentByX:location.x], [self.graph getValByY:location.y], location.x, location.y);
    }
    [self layoutSelectedPoint];
}

- (void)layoutSelectedPoint{
    if (selectedPointArgument != selectedPointArgument)
        return;
    NSArray *prevPoint;
    for (int i =0; i < _chartData.count; i++){
        NSArray *point = _chartData[i];
        NSArray *currentPoint = _chartData[i];
        if (selectedPointArgument <= [point[0] doubleValue] ){
            for (int j = 0; j < ((NSArray *)currentPoint[1]).count; j++){
                id val = currentPoint[1][j];
                if ([val isKindOfClass:[NSNull class]])
                    continue;
                
                CGPoint pointInGrid = [self.graph pointByValueInGrid:@[currentPoint[0], val]];
                if (prevPoint && prevPoint[1][j] && ![prevPoint[1][j] isKindOfClass:[NSNull class]]){
                    if (([point[0]doubleValue] - selectedPointArgument) >
                        (selectedPointArgument - [prevPoint[0]doubleValue])){
                        pointInGrid = [self.graph pointByValueInGrid:@[prevPoint[0], prevPoint[1][j]]];
                        currentPoint = prevPoint;
                    } else {
                        currentPoint = point;
                    }
                }
                UIView *selectedPoint;
                if (selectedPoints.count < (j+1)){
                    selectedPoint = [self createSelPoint:j];
                    if (!_nciSelPointImages ||
                        _nciSelPointImages.count <= j ||
                        [_nciSelPointImages[j]isKindOfClass:[NSNull class]]){
                        if(_nciSelPointColors.count > j && ![_nciSelPointColors[j] isKindOfClass:[NSNull class]]){
                            selectedPoint.backgroundColor =  _nciSelPointColors[j];
                        } else {
                            UIColor *newColor = [UIColor colorWithRed:(arc4random() % 255)/255.0f
                                                                green:(arc4random() % 255)/255.0f
                                                                 blue:(arc4random() % 255)/255.0f alpha:1.0];
                            selectedPoint.backgroundColor =  newColor;
                            if (_nciSelPointColors.count <= j){
                                [_nciSelPointColors addObject:newColor];
                            } else {
                                [_nciSelPointColors replaceObjectAtIndex:j withObject:newColor];
                            }
                        }
                    }  
                } else {
                    selectedPoint = selectedPoints[j];
                }
                selectedPoint.hidden = NO;
                selectedPoint.center = CGPointMake(pointInGrid.x + self.graph.chart.nciGridLeftMargin, pointInGrid.y + _nciGridTopMargin);
                if (pointInGrid.x < 0 || pointInGrid.x >= (self.graph.grid.frame.size.width + 2)){
                    selectedPoint.hidden = YES;
                } else {
                    selectedPoint.hidden = NO;
                }
            }
            
            if (self.nciSelPointTextRenderer){
                NSObject *text = self.nciSelPointTextRenderer([currentPoint[0] doubleValue], currentPoint[1]);
                if ([text isKindOfClass:[NSAttributedString class]]){
                    _selectedLabel.attributedText = (NSAttributedString *)text;
                } else {
                    _selectedLabel.text = (NSString *)text;
                }
            } else {
                NSMutableString *values = [[NSMutableString alloc] init];
                for (id val in currentPoint[1]){
                    if (![val isKindOfClass:[NSNull class]]){
                        [values appendString:[val description]];
                        [values appendString:@","];
                    }
                }
                if (_nciUseDateFormatter){
                    _selectedLabel.text = [NSString stringWithFormat:@"y: %@  x:%@", values,
                                           [dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970:[currentPoint[0] doubleValue]]]];
                } else {
                    _selectedLabel.text = [NSString stringWithFormat:@"y: %@  x:% 0.1f", values, [currentPoint[0] doubleValue]];
                }
            }
            return;
        }
        prevPoint = point;
    }
    for (UIView *selectedPoint in selectedPoints){
        _selectedLabel.text = @"";
        selectedPoint.hidden = YES;
    }
    selectedPointArgument = NAN;
}

- (void)layoutSubviews{
    _graph.frame = CGRectMake(_nciGridLeftMargin, _nciGridTopMargin, self.bounds.size.width - _nciGridLeftMargin - _nciGridRightMargin,
                              self.bounds.size.height - _nciGridTopMargin - _nciGridBottomMargin);
    //[_graph layoutSubviews];
    if (_nciHasSelection){
        _selectedLabel.frame = CGRectMake(0, 0, self.bounds.size.width, _nciGridTopMargin);;
        [self layoutSelectedPoint];
    }
}

- (void)addPoint:(double)arg val:(NSArray *)values{
    [self.chartData addObject:@[@(arg), values]];
}

-(void)drawChart{
    [self setNeedsLayout];
}

- (NSArray *)getBoundaryValues{
    float minY = MAXFLOAT;
    float maxY = -MAXFLOAT;
    for (NSArray *points in self.chartData){
        for (NSNumber *point in points[1]){
            if ([point isKindOfClass:[NSNull class]]){
                continue;
            }
            float val = [point floatValue];
            if (val < minY){
                minY = val;
            }
            if (val > maxY){
                maxY = val;
            }
        }
    }
    float diff = (maxY - minY);
    if (diff == 0){
        maxY = maxY + 1;
        minY = minY - 1;
    }
    return @[@(minY - diff*_topBottomGridSpace/100), @(maxY + diff*_topBottomGridSpace/100)];
}

@end
