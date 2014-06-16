//
//  RZTween.h
//  Raizlabs
//
//  Created by Nick D on 1/3/14.

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

@import Foundation;

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
 *  A subclass of RZTween provides a way to interpolate a value of an arbitrary numerical type.
 *  A tween can be used as-is or with RZTweenAnimator.
 */
@interface RZTween : NSObject <NSCopying>

/**
 *  The animation curve type to use for a paticular tween
 */
@property (nonatomic, assign) RZTweenCurveType curveType;

/**
 *  Returns @0 by default.  Should subclass to return appropriate type wrapped in NSValue
 *
 *  @param time animation offset
 *
 *  @return value for KVC.
 */
- (NSValue *)valueAtTime:(NSTimeInterval)time;

- (BOOL)isEqualToTween:(RZTween *)tween;

@end

/**
 * Tween for float values
 */
@interface RZFloatTween : RZTween

- (void)addKeyFloat:(CGFloat)keyFloat atTime:(NSTimeInterval)time;

@end

/**
 *  Tween for boolean values.
 *  Obviously can't interpolate between bool values,
 *  so this simply returns the most recent boolean keyframe value.
 */
@interface RZBooleanTween : RZTween

- (void)addKeyBool:(BOOL)keyBool atTime:(NSTimeInterval)time;

@end

/**
 * Tween for CGAffineTransform values.
 * @warning Performs direct linear interpolation between matrices. Rotation transforms
 *          will NOT work correctly.
 */
@interface RZTransformTween : RZTween

- (void)addKeyTransform:(CGAffineTransform)transform atTime:(NSTimeInterval)time;

@end

/**
 * Tween for CGRect values.
 */
@interface RZRectTween : RZTween

- (void)addKeyRect:(CGRect)rect atTime:(NSTimeInterval)time;

@end

/**
 * Tween for CGPoint values.
 */
@interface RZPointTween : RZTween

- (void)addKeyPoint:(CGPoint)point atTime:(NSTimeInterval)time;

@end

// TODO:
// - Color
// - Bounce Curves.
