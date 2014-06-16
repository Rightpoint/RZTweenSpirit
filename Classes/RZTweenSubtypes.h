//
//  RZTweenSubtypes.h
//  RZTweenSpirit
//
//  Created by Nick Donaldson on 6/16/14.
//
// Copyright 2014 Raizlabs and other contributors
// http://raizlabs.com/
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

/*
 *  This file provides several concrete implementations of RZTween for use
 *  with RZTweenAnimator. You can also create custom implementations of RZTween
 *  yourself in order to provide more complex tweening.
 */


@import UIKit;
#import "RZTween.h"

/**
 *  Different animation curves that are supported by the tween.
 */
typedef NS_ENUM(NSUInteger, RZTweenCurveType)
{
    /**
     *  y = x
     */
    RZTweenCurveTypeLinear = 0,
    /**
     *  y = x^2
     */
    RZTweenCurveTypeQuadraticEaseIn,
    /**
     *  y = -(x * (x-2))
     */
    RZTweenCurveTypeQuadraticEaseOut,
    /**
     *  see RZTweenQuadraticEaseInOut for description.
     */
    RZTweenCurveTypeQuadraticEaseInOut,
    /**
     *  y = sin(π/2 * (x-1))
     */
    RZTweenCurveTypeSineEaseIn,
    /**
     *  y = sin(π/2 * x)
     */
    RZTweenCurveTypeSineEaseOut,
    /**
     *  y = (1 - cos(π * x))/2
     */
    RZTweenCurveTypeSineEaseInOut
};

/**
 *  Provides a baseline implementation of RZTween for other concrete subtypes.
 *  This tween provides facilities for keyframe-based tweening, with particular values
 *  anchored to particular times and easing between these keyframes.
 *
 *  @note This class should not be used directly as it will always return 0 for its value.
 *        Use one of the subclasses instead.
 */
@interface RZKeyFrameTween : NSObject <RZTween>

/**
 *  The animation curve type to use for this paticular tween.
 *  Defaults to RZTweenCurveTypeLinear.
 */
@property (nonatomic, readonly, assign) RZTweenCurveType curveType;

/**
 *  Initialize with a particular curve type.
 *  The default initializer will use RZTweenCurveTypeLinear.
 *
 *  @param curveType The curve type to use in this tween.
 *
 *  @return A new instance of the tween.
 */
- (instancetype)initWithCurveType:(RZTweenCurveType)curveType;


- (void)addKeyFrameWithValue:(NSValue *)value atTime:(NSTimeInterval)time;


- (NSArray *)nearestKeyFramesForTime:(NSTimeInterval)time;

@end


/**
 * Tween for float values.
 */
@interface RZFloatTween : RZKeyFrameTween

/**
 *  Add a float value to be anchored at a particular time.
 *
 *  @param keyFloat The float value for the particular time.
 *  @param time     The time at which to anchor the float value.
 */
- (void)addKeyFloat:(CGFloat)keyFloat atTime:(NSTimeInterval)time;

@end

/**
 *  Tween for boolean values.
 *  Obviously can't interpolate between bool values,
 *  so this simply returns the most recent boolean keyframe value.
 */
@interface RZBooleanTween : RZKeyFrameTween

- (void)addKeyBool:(BOOL)keyBool atTime:(NSTimeInterval)time;

@end

/**
 * Tween for CGAffineTransform values.
 * @warning Performs direct linear interpolation between matrices. Rotation transforms
 *          will NOT work correctly.
 */
@interface RZTransformTween : RZKeyFrameTween

- (void)addKeyTransform:(CGAffineTransform)transform atTime:(NSTimeInterval)time;

@end

/**
 * Tween for CGRect values.
 */
@interface RZRectTween : RZKeyFrameTween

- (void)addKeyRect:(CGRect)rect atTime:(NSTimeInterval)time;

@end

/**
 * Tween for CGPoint values.
 */
@interface RZPointTween : RZKeyFrameTween

- (void)addKeyPoint:(CGPoint)point atTime:(NSTimeInterval)time;

@end

// TODO:
// - Color
// - Bounce Curves.