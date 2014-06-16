//
//  RZTween.h
//  RZTweenSpirit
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
 *  An object implementing RZTween provides a mechanism by which to retrieve
 *  a value of an arbitrary numerical type (or anything that can be boxed by NSValue)
 *  at a particular time. A tween can be used as-is or with RZTweenAnimator.
 *
 *  @see RZTweenSubtypes.h for several concrete implementations.
 */

@protocol RZTween <NSObject, NSCopying>

/**
 *  Return the value of the tween at a particular point along a timeline.
 *
 *  @param The time along the timeline at which to get the value.
 *
 *  @return Value for the provided time.
 */
- (NSValue *)tweenedValueAtTime:(NSTimeInterval)time;

/**
 *  Return whether another tween is equal to this one.
 *
 *  @param tween Some other tween.
 *
 *  @return Whether the tweens are equal.
 */
- (BOOL)isEqualToTween:(id<RZTween>)tween;

@end
