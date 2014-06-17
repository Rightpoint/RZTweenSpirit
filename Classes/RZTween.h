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
 *  An object implementing @p RZTween provides a mechanism by which to retrieve
 *  a value of an arbitrary type at a particular time. Objects which implement
 *  @p RZTween should be added to an instance of @p RZTweenAnimator.
 *
 *  @see  @p RZTweenSubtypes.h for several concrete keyframe-based implementations of @p RZTween.
 */

@protocol RZTween <NSObject, NSCopying>

/**
 *  The class of value represented by this tween.
 *  Since neither objc nor swift have parameterized protocols, this is the
 *  best we can do to ensure the tween deals with a consistent type.
 *
 *  @return The class of value represented by this tween.
 */
+ (Class)tweenedValueClass;

/**
 *  Return the value of the tween at a particular point along a timeline.
 *
 *  @param The time along the timeline at which to get the value.
 *
 *  @return Value for the provided time.
 */
- (id)tweenedValueAtTime:(NSTimeInterval)time;

@end
