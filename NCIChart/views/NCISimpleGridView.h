//
//  NCISimpleGridView.h
//  NCIChart
//
//  Created by Ira on 12/22/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCISimpleGraphView.h"

@interface NCISimpleGridView : UIView

@property(nonatomic, strong) NCISimpleGraphView *graph;

- (id)initWithGraph:(NCISimpleGraphView *) ncigraph;
- (UIColor *)getColor:(int) i;

@end
