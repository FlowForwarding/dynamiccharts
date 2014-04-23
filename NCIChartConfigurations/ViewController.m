//
//  ViewController.m
//  NCIChartConfigurations
//
//  Created by Ira on 12/20/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import "ViewController.h"
#import "NCIBarGraphView.h"
#import "NCIChartView.h"
#import "NCIZoomGraphView.h"

@interface ViewController (){
    NCISimpleChartView *simpleChart;
    
    float horisontalIndent;
    float verticalIndent;
    
    
    bool isShowingLandscapeView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        horisontalIndent = 20;
        verticalIndent = 40;
    } else {
        horisontalIndent = 10;
        verticalIndent = 20;
    }
    
    UIScrollView *pages = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    pages.contentSize = CGSizeMake(self.view.frame.size.height * 4, self.view.frame.size.width);
    pages.pagingEnabled = YES;
    pages.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:pages];
    
    simpleChart = [[NCISimpleChartView alloc]
                   initWithFrame:CGRectMake(50, 30, 400, 250)
                   andOptions: @{
                                 
                                 nciIsFill: @[@(NO), @(NO)],
                                 nciIsSmooth: @[@(NO), @(YES)],
                                 nciLineColors: @[[UIColor orangeColor], [NSNull null]],
                                 nciLineWidths: @[@2, [NSNull null]],
                                 nciHasSelection: @YES,
                                 nciSelPointColors: @[[UIColor redColor]],
                                 nciSelPointImages: @[[NSNull null], @"star"],
                                 nciSelPointTextRenderer: ^(double argument, NSArray* values){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MMM-dd HH:mm:ss"];
        return [[NSAttributedString alloc] initWithString:
                [NSString stringWithFormat:@"y: %.0f,%.0f  x:%@",
                 [values[0] floatValue],
                 [values[1] floatValue],
                 [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970: argument]]]
                                               attributes: @{NSForegroundColorAttributeName: [UIColor redColor],
                                                             NSFontAttributeName: [UIFont fontWithName:@"MarkerFelt-Thin" size:12]}];
    },
                                 
                                 nciSelPointSizes: @[@10, [NSNull null]],
                                 
                                 //                                               nciTapGridAction: ^(double argument, double value, float xInGrid, float yInGrid){
                                 //
                                 //    },
                                 nciShowPoints : @NO,
                                 nciUseDateFormatter: @YES,//nciXLabelRenderer
                                 nciXAxis: @{nciLineColor: [UIColor redColor],
                                             nciLineDashes: @[],
                                             nciLineWidth: @2,
                                             nciLabelsFont: [UIFont fontWithName:@"MarkerFelt-Thin" size:12],
                                             nciLabelsColor: [UIColor blueColor],
                                             nciLabelsDistance: @120,
                                             nciUseDateFormatter: @YES
                                             },
                                 nciYAxis: @{nciLineColor: [UIColor blackColor],
                                             nciLineDashes: @[@2,@2],
                                             nciLineWidth: @1,
                                             nciLabelsFont: [UIFont fontWithName:@"MarkerFelt-Thin" size:12],
                                             nciLabelsColor: [UIColor brownColor],
                                             nciLabelsDistance: @30,
                                             nciLabelRenderer: ^(double value){
        
        return [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"%.1f$", value]
                                               attributes:@{NSForegroundColorAttributeName: [UIColor brownColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"MarkerFelt-Thin" size:12]}];
    },
                                             },
                                 nciGridVertical: @{nciLineColor: [UIColor purpleColor],
                                                    nciLineDashes: @[],
                                                    nciLineWidth: @1},
                                 nciGridHorizontal: @{nciLineColor: [UIColor greenColor],
                                                      nciLineDashes: @[@2,@2],
                                                      nciLineWidth: @2},
                                 nciGridColor: [[UIColor magentaColor] colorWithAlphaComponent:0.1],
                                 nciGridLeftMargin: @50,
                                 nciGridTopMargin: @50,
                                 nciGridBottomMargin: @40
                                 }];
    
    simpleChart.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.2];
    [pages addSubview:simpleChart];
    
    
    NCISimpleChartView *zoomingChart =  [[NCISimpleChartView alloc] initWithFrame:
                                         CGRectMake(self.view.frame.size.height + 50, 30, 400, 250)
                                                                       andOptions:@{nciGraphRenderer: [NCIZoomGraphView class],
                                                                                    nciIsSmooth: @[@YES],
                                                                                    nciYAxis: @{
                                                                                            nciAxisShift: @320,
                                                                                            nciInvertedLabes: @YES,
                                                                                            nciLineDashes: @[],
                                                                                            nciLineWidth: @2
                                                                                            },
                                                                                    nciXAxis: @{
                                                                                            nciLineColor: [UIColor greenColor],
                                                                                            nciLineWidth: @2,
                                                                                            nciAxisShift : @90,
                                                                                            nciInvertedLabes: @YES
                                                                                            }}];
    
    [pages addSubview:zoomingChart];
    
    int numOfPoints = 10;
    for (int ind = 0; ind < numOfPoints; ind ++){
        [zoomingChart addPoint:ind val:@[@(arc4random() % 5)]];
    }
    
    NCIChartView *nciChart =  [[NCIChartView alloc] initWithFrame:
                                         CGRectMake(2*self.view.frame.size.height + 50, 30, 400, 250)];
    
    [pages addSubview:nciChart];
    nciChart.minRangeVal = 5;
    nciChart.maxRangeVal = 8;
    

    for (int ind = 0; ind < 50; ind ++){
        if (ind % 5 == 0){
            [nciChart addPoint:ind val:@[[NSNull null]]];
        } else {
            [nciChart addPoint:ind val:@[@(arc4random() % 5)]];
        }
    }
    
    NCISimpleChartView *barChart =  [[NCISimpleChartView alloc] initWithFrame:
                               CGRectMake(3*self.view.frame.size.height + 50, 30, 400, 250)
                                                                   andOptions:@{nciGraphRenderer: [NCIBarGraphView class],
                                                                                nciYAxis: @{
                                                                                        nciAxisShift: @320,
                                                                                        nciInvertedLabes: @YES,
                                                                                        nciLineDashes: @[]
                                                                                        },
                                                                                nciXAxis: @{
                                                                                        nciLineColor: [UIColor greenColor],
                                                                                        nciAxisShift : @40,
                                                                                        nciInvertedLabes: @YES,
                                                                                        nciLineDashes: @[]
                                                                                }
                                                                    }
                                     ];
    
    [pages addSubview:barChart];
    
    for (int ind = 0; ind < 10; ind ++){
        [barChart addPoint:ind val:@[@(-arc4random() % 5)]];
    }
    ////  chart.minRangeVal = 5;
    //    chart.maxRangeVal = 8;
    
    
    [self generateDemoData];
    
    
}


- (void)generateDemoData{
    float halfYearPeriod = 60*60*24*30*6;
    float demoDatePeriod = halfYearPeriod;
    float numOfPoints = 15;
    float step = demoDatePeriod/(numOfPoints - 1);
    int trendMiddle = 6;
    int trendStepCounter = 0;
    int ind;
    for (ind = 0; ind < numOfPoints; ind ++){
        if (trendStepCounter > 20){
            trendStepCounter = 0;
            trendMiddle += 1;
        }
        trendStepCounter += 1;
        int value = trendMiddle + arc4random() % 5;
        //NSDate *date = [[NSDate date] dateByAddingTimeInterval: (-demoDatePeriod + step*ind)];
        double time = [[NSDate date] timeIntervalSince1970] - demoDatePeriod + step*ind;
        //        if (trendStepCounter > 4 && trendStepCounter < 7){
        //            [simpleChart addPoint:time val: @[[NSNull null]]];
        //        } else {
        [simpleChart addPoint:time val: @[@(value), @(trendMiddle + arc4random() % 5)]];
        // }
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
