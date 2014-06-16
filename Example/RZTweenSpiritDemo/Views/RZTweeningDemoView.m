//
//  RZTweeningDemoView.m
//  RZTweenSpiritDemo
//
//  Created by Nick Donaldson on 6/16/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZTweeningDemoView.h"

static CGFloat const kRZTweeningDemoViewScrollHeight = 2000.f;

@interface RZTweeningDemoView () <UIScrollViewDelegate>

@property (nonatomic, readwrite, strong) RZTweenAnimator *tweenAnimator;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UILabel *bulgingLabel;

@end

@implementation RZTweeningDemoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        _scrollView = scrollView;

        UILabel *bulgingLabel = [[UILabel alloc] init];
        bulgingLabel.translatesAutoresizingMaskIntoConstraints = NO;
        bulgingLabel.text = @"RZTweenSpirit";
        bulgingLabel.font = [UIFont systemFontOfSize:28];
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
     * This label has constraints, but its transform can still be animated.
     */
    NSInteger const nBulges     = 4;
    CGFloat   const bulgeScale  = 1.5;
    
    RZTransformTween *bulgeLabelTween = [[RZTransformTween alloc] init];
    
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
    }];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat totalScrollLength = scrollView.contentSize.height - CGRectGetHeight(scrollView.frame);
    CGFloat normalizedTime    = scrollView.contentOffset.y / totalScrollLength;
    [self.tweenAnimator setTime:normalizedTime];
}

@end
