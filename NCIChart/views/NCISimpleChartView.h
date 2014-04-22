//
//  NCISimpleChartView.h
//  NCIChart
//
//  Created by Ira on 12/20/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCIChartOptions.h"
#import "NCILine.h"
#import "NCIAxis.h"

@class NCISimpleGraphView;

@interface NCISimpleChartView : UIView

@property (nonatomic, strong)NCISimpleGraphView *graph;
@property (nonatomic, strong)NSMutableArray *chartData;
@property (nonatomic, strong)NCIAxis *xAxis;
@property (nonatomic, strong)NCIAxis *yAxis;

@property (nonatomic, strong)UILabel *selectedLabel;
@property (nonatomic)bool nciUseDateFormatter;
@property (nonatomic)bool nciShowPoints;
@property (nonatomic)NSMutableArray* nciIsFill;
@property (nonatomic)NSMutableArray* nciIsSmooth;
@property (nonatomic)NSArray* nciLineWidths;
@property (nonatomic, strong)NSMutableArray* nciLineColors;

@property (nonatomic)bool nciHasSelection;
@property (nonatomic)bool nciHasHorizontalGrid;
@property (nonatomic, strong)NSMutableArray* nciSelPointColors;
@property (nonatomic, strong)NSMutableArray* nciSelPointImages;
@property (nonatomic)NSArray* nciSelPointSizes;

//callbacks
@property (nonatomic, copy) NSAttributedString* (^nciSelPointTextRenderer)(double, NSArray *);
@property (nonatomic, copy) void (^nciTapGridAction)(double, double, float, float);
//in persentage
@property (nonatomic)float topBottomGridSpace;
@property (nonatomic)float leftRightGridSpace;

@property (nonatomic, strong) NCILine* nciGridVertical;
@property (nonatomic, strong) NCILine* nciGridHorizontal;
@property (nonatomic, strong) UIColor* nciGridColor;
@property (nonatomic) float nciGridLeftMargin;
@property (nonatomic) float nciGridRightMargin;
@property (nonatomic) float nciGridTopMargin;
@property (nonatomic) float nciGridBottomMargin;

@property (nonatomic, copy) NSString* nciLeftRangeImageName;
@property (nonatomic, copy) NSString* nciRightRangeImageName;

@property(nonatomic)double minRangeVal;
@property(nonatomic)double maxRangeVal;

-(id)initWithFrame:(CGRect)frame andOptions:(NSDictionary *)opts;

- (void)drawChart;
- (void)addSubviews;
- (void)addPoint:(double)arg val:(NSArray *)values;
- (NSArray *)getBoundaryValues;
- (void)layoutSelectedPoint;
- (void)defaultSetup;

- (void)simulateTapGrid:(double) xPos;

@end
