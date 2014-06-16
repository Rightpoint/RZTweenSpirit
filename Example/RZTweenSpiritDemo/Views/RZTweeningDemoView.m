//
//  RZTweeningDemoView.m
//  RZTweenSpiritDemo
//
//  Created by Nick Donaldson on 6/16/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZTweeningDemoView.h"

static CGFloat const kRZTweeningDemoViewScrollHeight        = 2000.f;
static CGFloat const kRZTweeningDemoViewCloud1StartXOffset  = -40.0;
static CGFloat const kRZTweeningDemoViewCloud2StartXOffset  = 40.0;

@interface RZTweeningDemoView () <UIScrollViewDelegate>

@property (nonatomic, readwrite, strong) RZTweenAnimator *tweenAnimator;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *cloud1;
@property (nonatomic, weak) UIImageView *cloud2;
@property (nonatomic, weak) UILabel *bulgingLabel;

@property (nonatomic, strong) NSLayoutConstraint *cloud1CenterX;
@property (nonatomic, strong) NSLayoutConstraint *cloud2CenterX;


@end

@implementation RZTweeningDemoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[self backgroundColors] objectAtIndex:0];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        _scrollView = scrollView;
        
        UIImageView *cloud1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud1"]];
        UIImageView *cloud2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud2"]];
        cloud1.translatesAutoresizingMaskIntoConstraints = NO;
        cloud2.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.cloud1CenterX = [NSLayoutConstraint constraintWithItem:cloud1
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:kRZTweeningDemoViewCloud1StartXOffset];
        
        self.cloud2CenterX = [NSLayoutConstraint constraintWithItem:cloud2
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:kRZTweeningDemoViewCloud2StartXOffset];
        
        [self addSubview:cloud1];
        [self addSubview:cloud2];
        
        [self addConstraint:self.cloud1CenterX];
        [self addConstraint:self.cloud2CenterX];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:cloud1
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:-20.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:cloud2
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:-40.0]];

        UILabel *bulgingLabel = [[UILabel alloc] init];
        bulgingLabel.translatesAutoresizingMaskIntoConstraints = NO;
        bulgingLabel.text = @"RZTweenSpirit";
        bulgingLabel.textAlignment = NSTextAlignmentCenter;
        bulgingLabel.font = [UIFont systemFontOfSize:28];
        bulgingLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:bulgingLabel];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:bulgingLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:40.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:bulgingLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];
        _bulgingLabel = bulgingLabel;

        
        _tweenAnimator = [[RZTweenAnimator alloc] init];
        [self setupTweens];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), kRZTweeningDemoViewScrollHeight);
}

- (void)setupTweens
{
    __weak __typeof__(self) weakSelf = self;
    
    /*
     *  Tween the background color!
     */
    RZColorTween *colorTween = [[RZColorTween alloc] initWithCurveType:RZTweenCurveTypeLinear];
    [[self backgroundColors] enumerateObjectsUsingBlock:^(UIColor *bgColor, NSUInteger idx, BOOL *stop) {
        [colorTween addKeyColor:bgColor atTime:(double)idx/[[self backgroundColors] count]];
    }];
    [self.tweenAnimator addTween:colorTween forKeyPath:@"backgroundColor" ofObject:self];
    
    /*
     *  The clouds have constraints, but we can animate those directly using KVC!
     */
    CGFloat const cloud1MaxOffset = -80.0;
    CGFloat const cloud2MaxOffset = 100.0;
    
    RZFloatTween *cloud1ParallaxTween = [[RZFloatTween alloc] initWithCurveType:RZTweenCurveTypeQuadraticEaseIn];
    [cloud1ParallaxTween addKeyFloat:kRZTweeningDemoViewCloud1StartXOffset atTime:0];
    [cloud1ParallaxTween addKeyFloat:kRZTweeningDemoViewCloud1StartXOffset - cloud1MaxOffset * 0.1 atTime:-0.1]; // for overscrolling
    [cloud1ParallaxTween addKeyFloat:kRZTweeningDemoViewCloud1StartXOffset + cloud1MaxOffset atTime:1.0];
    [cloud1ParallaxTween addKeyFloat:kRZTweeningDemoViewCloud1StartXOffset + cloud1MaxOffset * 1.1 atTime:1.1]; // for overscrolling
    
    RZFloatTween *cloud2ParallaxTween = [[RZFloatTween alloc] initWithCurveType:RZTweenCurveTypeQuadraticEaseIn];
    [cloud2ParallaxTween addKeyFloat:kRZTweeningDemoViewCloud2StartXOffset atTime:0];
    [cloud2ParallaxTween addKeyFloat:kRZTweeningDemoViewCloud2StartXOffset - cloud2MaxOffset * 0.1 atTime:-0.1]; // for overscrolling
    [cloud2ParallaxTween addKeyFloat:kRZTweeningDemoViewCloud2StartXOffset + cloud2MaxOffset atTime:1.0];
    [cloud2ParallaxTween addKeyFloat:kRZTweeningDemoViewCloud2StartXOffset + cloud2MaxOffset * 1.1 atTime:1.1]; // for overscrolling
    
    [self.tweenAnimator addTween:cloud1ParallaxTween forKeyPath:@"constant" ofObject:self.cloud1CenterX];
    [self.tweenAnimator addTween:cloud2ParallaxTween forKeyPath:@"constant" ofObject:self.cloud2CenterX];

    /*
     * The banner label has constraints, but its transform can still be animated.
     */
    NSInteger const nBulges     = 4;
    CGFloat   const bulgeScale  = 1.5;
    
    RZTransformTween *bulgeLabelTween = [[RZTransformTween alloc] initWithCurveType:RZTweenCurveTypeSineEaseInOut];
    
    // Give the indexes some padding on either side for overscroll
    for ( NSInteger i = -1; i <= nBulges + 1; i++ ) {
        NSTimeInterval normalizedTime = (double)i/nBulges;
        if ( i % 2 == 0 ) {
            [bulgeLabelTween addKeyTransform:CGAffineTransformIdentity atTime:normalizedTime];
        }
        else {
            [bulgeLabelTween addKeyTransform:CGAffineTransformMakeScale(bulgeScale, bulgeScale) atTime:normalizedTime];
        }
    }
    
    /*
     * The layer transform provides much more efficient animation than the view
     * transform when autolayout is running the show.
     */
    [self.tweenAnimator addTween:bulgeLabelTween withUpdateBlock:^(NSValue *value) {
        CATransform3D layerTransform = CATransform3DMakeAffineTransform([value CGAffineTransformValue]);
        weakSelf.bulgingLabel.layer.transform = layerTransform;
        [weakSelf setNeedsLayout];
    }];
    
}

- (NSArray *)backgroundColors
{
    static NSArray *s_bgColors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_bgColors = @[ [UIColor colorWithRed:0.5059 green:0.5098 blue:0.5255 alpha:1.0000],
                        [UIColor colorWithRed:0.7255 green:0.7020 blue:0.6471 alpha:1.0000],
                        [UIColor colorWithRed:0.9098 green:0.7098 blue:0.4863 alpha:1.0000],
                        [UIColor colorWithRed:0.3176 green:0.5725 blue:0.8431 alpha:1.0000] ];
    });
    return s_bgColors;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
     * When the scrollview scrolls, set the tween animator's time. This will update all tweens.
     */
    CGFloat totalScrollLength = scrollView.contentSize.height - CGRectGetHeight(scrollView.frame);
    CGFloat normalizedTime    = scrollView.contentOffset.y / totalScrollLength;
    [self.tweenAnimator setTime:normalizedTime];
}

@end
