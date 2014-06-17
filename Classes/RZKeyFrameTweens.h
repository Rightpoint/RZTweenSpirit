//
//  RZKeyFrameTweens.h
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
     *  see RZTweenQuadraticEaseInOut in implementation file for description.
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

// ----------------------

/**
 *  Provides a keyframe-based abstract base implementation of RZTween for particular value types.
 *  This tween provides facilities for keyframe-based tweening, with particular values
 *  anchored to particular times and easing between these keyframes.
 *
 *  @warning Do not use this class directly. Rather, subclass it or use one of the concrete subclasses.
 *           Attempting to call @p -tweenValueAtTime on this class will throw a runtime exception.
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
 *  @param curveType The curve type to use with this tween.
 *
 *  @return A new instance of the tween.
 */
- (instancetype)initWithCurveType:(RZTweenCurveType)curveType;

/**
 *  Add a keyframe with a particular value at a particular time.
 *
 *  @param value Value for the keyframe.
 *  @param time  Time for the keyframe.
 *
 *  @warning The values passed in must represent the same class that is returned by +valueClass.
 *           Subclasses should implement a typed version of this method which calls through to this 
 *           implementation. See @p RZFloatTween for an example.
 */
- (void)addKeyValue:(id)value atTime:(NSTimeInterval)time;

/**
 *  Returns a value linearly interpolated between two keyframe times.
 *  The delta will be calculated based on the time difference and curve type.
 *
 *  @param fromValue The value from which to interpolate.
 *  @param fromTime  The time from which to interpolate.
 *  @param toValue   The value to which to interpolate.
 *  @param toTime    The time to which to interpolate.
 *  @param delta     The linear delta between the two values to use for interpolation. (Between 0-1).
 *
 *  @note This is intended to be overridden in subclasses; do not call this method directly.
 *
 *  @return The interpolated value.
 */
- (id)interpolatedValueFromKeyValue:(id)fromValue
                             atTime:(NSTimeInterval)fromTime
                         toKeyValue:(id)toValue
                             atTime:(NSTimeInterval)toTime
                          withDelta:(float)delta;

@end

// ----------------------

/**
 *  Tween for scalar floating-point (CGFloat) values.
 *  Value type returned is NSNumber wrapping CGFloat
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

// ----------------------

/**
 *  Tween for boolean values.
 *  Value type returned is NSValue wrapping BOOL.
 *
 *  @note Obviously it's not logical to interpolate between bool values,
 *        so this simply returns the most recent boolean keyframe value.
 */
@interface RZBooleanTween : RZKeyFrameTween

- (void)addKeyBool:(BOOL)keyBool atTime:(NSTimeInterval)time;

@end

// ----------------------

/**
 *  Tween for CGRect values.
 *  Value type returned is NSValue wrapping CGRect.
 */
@interface RZRectTween : RZKeyFrameTween

- (void)addKeyRect:(CGRect)rect atTime:(NSTimeInterval)time;

@end

// ----------------------

/**
 *  Tween for CGPoint values.
 *  Value type returned is NSValue wrapping CGPoint.
 */
@interface RZPointTween : RZKeyFrameTween

- (void)addKeyPoint:(CGPoint)point atTime:(NSTimeInterval)time;

@end

// ----------------------

/**
 *  Tween for UIColor values.
 *  Value type returned is UIColor.
 */
@interface RZColorTween : RZKeyFrameTween

- (void)addKeyColor:(UIColor *)color atTime:(NSTimeInterval)time;

@end



// TODO:
// - Bounce Curves.