//
//  RZTweeningDemoView.m
//  RZTweenSpiritDemo
//
//  Created by Nick Donaldson on 6/16/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZTweeningDemoView.h"

static CGFloat const kRZTweeningDemoViewScrollWidthMultiplier   = 5.0;
static CGFloat const kRZTweeningDemoViewCloud1StartXOffset      = -60.0;
static CGFloat const kRZTweeningDemoViewCloud2StartXOffset      = -10.0;

@interface RZTweeningDemoView () <UIScrollViewDelegate>

@property (nonatomic, readwrite, weak) UIButton *startButton;

@property (nonatomic, readwrite, strong) RZTweenAnimator *tweenAnimator;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIImageView *cloud1;
@property (nonatomic, weak) UIImageView *cloud2;
@property (nonatomic, weak) UIImageView *starView;

@property (nonatomic, strong) NSLayoutConstraint *cloud1CenterX;
@property (nonatomic, strong) NSLayoutConstraint *cloud2CenterX;

@property (nonatomic, weak) UILabel *arrowLabel;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, strong) NSLayoutConstraint *labelYConstraint;

@end

@interface RZTweeningDemoView (Setup)

- (void)setupSubviews;
- (void)setupTweens;

@end

@implementation RZTweeningDemoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[self backgroundColors] objectAtIndex:0];
        _tweenAnimator = [[RZTweenAnimator alloc] init];
        [self setupSubviews];
        [self setupTweens];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * kRZTweeningDemoViewScrollWidthMultiplier,
                                             CGRectGetWidth(self.bounds));
    
    // Size the arrow label
    [self.arrowLabel sizeToFit];
    self.arrowLabel.center = CGPointMake(CGRectGetWidth(self.bounds) - 80.0,
                                         CGRectGetHeight(self.bounds) * 0.5);
    
    // Size the title label
    [self.titleLabel sizeToFit];
    UIView *labelContainer = [self.titleLabel superview];
    self.titleLabel.center = CGPointMake(CGRectGetWidth(labelContainer.bounds) * 0.5, CGRectGetHeight(labelContainer.bounds) * 0.5);
    
    // account for anchor point
    self.starView.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds));
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self.scrollView setContentOffset:CGPointZero];
    [self.tweenAnimator setTime:0];
}



- (NSArray *)backgroundColors
{
    static NSArray *s_bgColors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_bgColors = @[ [UIColor colorWithRed:0.1 green:0.1 blue:0.15 alpha:1.0000],
                        [UIColor colorWithRed:0.8863 green:0.5137 blue:0.3255 alpha:1.0000],
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
    CGFloat totalScrollLength = scrollView.contentSize.width - CGRectGetWidth(scrollView.frame);
    CGFloat normalizedTime    = scrollView.contentOffset.x / totalScrollLength;
    [self.tweenAnimator setTime:normalizedTime];
}

@end

@implementation RZTweeningDemoView (Setup)

- (void)setupSubviews
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    UILabel *arrowLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    arrowLabel.backgroundColor = [UIColor clearColor];
    arrowLabel.font = [UIFont systemFontOfSize:28];
    arrowLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    arrowLabel.text = @"Drag Me →";
    [self.scrollView addSubview:arrowLabel];
    _arrowLabel = arrowLabel;
    
    UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    startButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    startButton.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    startButton.adjustsImageWhenDisabled = NO;
    [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    [startButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [startButton setTitle:@"Start!" forState:UIControlStateNormal];
    [self addSubview:startButton];
    _startButton = startButton;
    
    UIImageView *cloud1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud1"]];
    UIImageView *cloud2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud2"]];
    [cloud1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cloud2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    
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
                                                      constant:60.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cloud2
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:20.0]];
    
    UIImageView *starView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stars"]];
    starView.translatesAutoresizingMaskIntoConstraints = NO;
    starView.layer.anchorPoint = CGPointMake(0.5, 1.0);
    [self insertSubview:starView atIndex:0];
    _starView = starView;
    
    // To pin to the center and still allow flexible scaling, we need a container to host the label.
    UIView *labelContainer = [[UIView alloc] init];
    labelContainer.userInteractionEnabled = NO;
    labelContainer.backgroundColor = [UIColor clearColor];
    [labelContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:labelContainer];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[container]-0-|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:@{ @"container" : labelContainer }]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[container]"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:@{ @"container" : labelContainer }]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:labelContainer
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:0.25
                                                      constant:0.0]];
    
    UILabel *titleLabel       = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text           = @"RZTweenSpirit";
    titleLabel.textAlignment  = NSTextAlignmentCenter;
    titleLabel.font           = [UIFont systemFontOfSize:42];
    titleLabel.textColor      = [UIColor whiteColor];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [labelContainer addSubview:titleLabel];
    _titleLabel = titleLabel;
}

- (void)setupTweens
{
    /*
     *  Tween the background color!
     */
    RZColorTween *colorTween = [[RZColorTween alloc] initWithCurveType:RZTweenCurveTypeLinear];
    CGFloat denominator = (CGFloat)[[self backgroundColors] count] - 1.0;
    [[self backgroundColors] enumerateObjectsUsingBlock:^(UIColor *bgColor, NSUInteger idx, BOOL *stop) {
        [colorTween addKeyColor:bgColor atTime:(double)idx/denominator];
    }];
    [self.tweenAnimator addTween:colorTween forKeyPath:@"backgroundColor" ofObject:self];
    
    /*
     *  Fade out the hint arrow!
     */
    RZFloatTween *arrowAlpha = [[RZFloatTween alloc] initWithCurveType:RZTweenCurveTypeSineEaseOut];
    [arrowAlpha addKeyFloat:1.0 atTime:0];
    [arrowAlpha addKeyFloat:0.0 atTime:0.1];
    [self.tweenAnimator addTween:arrowAlpha forKeyPath:@"alpha" ofObject:self.arrowLabel];
    
    /*
     *  Tween the start button!
     *  You can tween frame/center properties of UIViews directly, but this is restrictive for different device sizes.
     *  But animation can also be done using autolayout (examples below) for dynamic, responsive view layouts.
     */
    CGFloat const buttonMaxOffsetY  = CGRectGetHeight(self.bounds) * 0.4;
    CGFloat const buttonNominalX    = CGRectGetWidth(self.bounds) * 0.5;
    CGFloat const buttonNominalY    = CGRectGetHeight(self.bounds) * 0.33;
    
    RZPointTween *buttonCenterTween = [[RZPointTween alloc] initWithCurveType:RZTweenCurveTypeQuadraticEaseOut];
    [buttonCenterTween addKeyPoint:CGPointMake(buttonNominalX, buttonNominalY + buttonMaxOffsetY) atTime:0];
    [buttonCenterTween addKeyPoint:CGPointMake(buttonNominalX, buttonNominalY) atTime:1];
    [self.tweenAnimator addTween:buttonCenterTween forKeyPath:@"center" ofObject:self.startButton];
    
    RZFloatTween *buttonAlphaTween = [[RZFloatTween alloc] initWithCurveType:RZTweenCurveTypeQuadraticEaseIn];
    [buttonAlphaTween addKeyFloat:0.0 atTime:0];
    [buttonAlphaTween addKeyFloat:1.0 atTime:1];
    [self.tweenAnimator addTween:buttonAlphaTween forKeyPath:@"alpha" ofObject:self.startButton];
    
    // Don't enable until we are all the way scrolled down
    RZBooleanTween *buttonEnabledTween = [[RZBooleanTween alloc] initWithCurveType:RZTweenCurveTypeLinear];
    [buttonEnabledTween addKeyBool:NO atTime:0];
    [buttonEnabledTween addKeyBool:YES atTime:0.9];
    [self.tweenAnimator addTween:buttonEnabledTween forKeyPath:@"enabled" ofObject:self.startButton];
    
    /*
     *  The clouds have constraints, but we can animate those directly using KVC!
     */
    CGFloat const cloud1MaxOffset = 160.0;
    CGFloat const cloud2MaxOffset = 40.0;
    
    RZFloatTween *cloud1ParallaxTween = [[RZFloatTween alloc] initWithCurveType:RZTweenCurveTypeQuadraticEaseInOut];
    [cloud1ParallaxTween addKeyFloat:kRZTweeningDemoViewCloud1StartXOffset - cloud1MaxOffset atTime:-0.2]; // for overscrolling
    [cloud1ParallaxTween addKeyFloat:kRZTweeningDemoViewCloud1StartXOffset + cloud1MaxOffset atTime:1.2]; // for overscrolling
    
    RZFloatTween *cloud2ParallaxTween = [[RZFloatTween alloc] initWithCurveType:RZTweenCurveTypeQuadraticEaseInOut];
    [cloud2ParallaxTween addKeyFloat:kRZTweeningDemoViewCloud2StartXOffset - cloud2MaxOffset atTime:-0.2]; // for overscrolling
    [cloud2ParallaxTween addKeyFloat:kRZTweeningDemoViewCloud2StartXOffset + cloud2MaxOffset atTime:1.2]; // for overscrolling
    
    [self.tweenAnimator addTween:cloud1ParallaxTween forKeyPath:@"constant" ofObject:self.cloud1CenterX];
    [self.tweenAnimator addTween:cloud2ParallaxTween forKeyPath:@"constant" ofObject:self.cloud2CenterX];
    
    /*
     *  Tween values can be used with CALayer keypaths, too!
     */
    CGFloat const labelMaxScale = 3.0;
    RZFloatTween *labelScaleTween = [[RZFloatTween alloc] initWithCurveType:RZTweenCurveTypeSineEaseOut];
    [labelScaleTween addKeyFloat:labelMaxScale atTime:0.0];
    [labelScaleTween addKeyFloat:1.0 atTime:0.7];
    [labelScaleTween addKeyFloat:1.0 atTime:1.0];
    [labelScaleTween addKeyFloat:1.5 atTime:1.2]; // overscroll
    [self.tweenAnimator addTween:labelScaleTween forKeyPath:@"transform.scale" ofObject:self.titleLabel.layer];
    
    const CGFloat labelMaxTranslationY = CGRectGetHeight(self.bounds) * 0.08;
    RZFloatTween *labelTranslateTween = [[RZFloatTween alloc] initWithCurveType:RZTweenCurveTypeSineEaseOut];
    [labelTranslateTween addKeyFloat:labelMaxTranslationY atTime:0.0];
    [labelTranslateTween addKeyFloat:labelMaxTranslationY atTime:0.7];
    [labelTranslateTween addKeyFloat:0.0 atTime:1.0];
    [self.tweenAnimator addTween:labelTranslateTween forKeyPath:@"transform.translation.y" ofObject:self.titleLabel.layer];
    
    RZFloatTween *labelAlphaTween = [[RZFloatTween alloc] initWithCurveType:RZTweenCurveTypeSineEaseIn];
    [labelAlphaTween addKeyFloat:0.0 atTime:0.0];
    [labelAlphaTween addKeyFloat:1.0 atTime:1.0];
    [self.tweenAnimator addTween:labelAlphaTween forKeyPath:@"alpha" ofObject:self.titleLabel];
    
    /*
     *  Spin those stars
     */
    CGFloat const starMaxRotation = M_PI * 0.08;
    RZFloatTween *starRotationTween = [[RZFloatTween alloc] initWithCurveType:RZTweenCurveTypeLinear];
    [starRotationTween addKeyFloat:-starMaxRotation atTime:-0.2];
    [starRotationTween addKeyFloat:starMaxRotation atTime:1.2];
    [self.tweenAnimator addTween:starRotationTween forKeyPath:@"transform.rotation" ofObject:self.starView.layer];
    
    RZFloatTween *starAlphaTween = [[RZFloatTween alloc] initWithCurveType:RZTweenCurveTypeQuadraticEaseOut];
    [starAlphaTween addKeyFloat:1.0 atTime:0.0];
    [starAlphaTween addKeyFloat:0.0 atTime:0.4];
    [self.tweenAnimator addTween:starAlphaTween forKeyPath:@"alpha" ofObject:self.starView];
}

@end