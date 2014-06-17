//
//  RZTweenAnimator.h
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
@import QuartzCore;
#import "RZTween.h"

typedef void (^RZTweenAnimatorUpdateBlock)(id<RZTween> tween, id value);

@protocol RZTweenAnimatorDelegate;

/**
 *  An animation controller for managing tweening timelines.
 */
@interface RZTweenAnimator : NSObject

/**
 *  Adds a tween for a paticular keyPath on an object.  If the data type for the tween doesn not match the exptected
 *  type for the keyPath, an exception will likely be raised.
 *
 *  @note @p object is not retained by this method.
 *
 *  @param tween   An object which implemens RZTween to be used to calculate a new value when the time is changed.
 *  @param keyPath The keypath that will be called using KVC
 *  @param object  The object that will be modified by the animator.
*/
- (void)addTween:(id<RZTween>)tween forKeyPath:(NSString *)keyPath ofObject:(id)object;

/**
 *  Add a tween with a frame update block.  Block is called for each update with the current tweened value.
 *
 *  @param tween      An object which implemens RZTween to be used to calculate a new value when the time is changed.
 *  @param frameBlock Block to be called when the animator updates its time.
 */
- (void)addTween:(id<RZTween>)tween withUpdateBlock:(RZTweenAnimatorUpdateBlock)frameBlock;

/**
 *  Remove a tween from the animator. Does nothing if tween is not registered with this animator.
 *
 *  @param tween Tween to remove. Must not be nil.
 */
- (void)removeTween:(id<RZTween>)tween;

/**
 *  Return an array of all tweens registered with this animator.
 *
 *  @return An array of objects conforming to @p RZTween.
 */
- (NSArray *)allTweens;

/**
 *  Represents the current position of the animation timeline.
 *  Set this to change the timeline position immediately and cancel an existing animation.
 */
@property (nonatomic, assign) NSTimeInterval time;

/**
 *  Force an animation to a paticular time.
 *
 *  @param time The position to animate too.
 */
- (void)animateToTime:(NSTimeInterval)time;

/**
 *  Animate to a paticular time over a set duration
 *
 *  @param time     the position to animate too.
 *  @param duration the duration of the animation.
 */
- (void)animateToTime:(NSTimeInterval)time overDuration:(NSTimeInterval)duration;

/**
 *  Immediately cancel any animation in progress.
 *  The timeline will be left in its current state whenever this is called.
 */
- (void)stopAnimating;

/**
 *  For notifying a delegate of the state of the RZTweenAnimator.
 */
@property (nonatomic, weak) id<RZTweenAnimatorDelegate> delegate;

@end

// ------------------------------------------------------------

/**
 *  Delegate protocol for observing animator state.
 */
@protocol RZTweenAnimatorDelegate <NSObject>

@optional

/**
 *  Called whenever an animation is started. 
 *  Will not be called when time is set directly.
 *
 *  @param animator The animator for which the animatino was started.
 *  @param time     The destination time offset for the animation.
 *  @param duration The duration of the animation.
 */
- (void)tweenAnimatorWillBeginAnimating:(RZTweenAnimator *)animator toTime:(NSTimeInterval)time overDuration:(NSTimeInterval)duration;

/**
 *  Called whenever the animator is updated, including during animations and when time is set directly.
 *
 *  @param animator The animator that animated.
 */
- (void)tweenAnimatorDidAnimate:(RZTweenAnimator *)animator;

/**
 *  Called when an animation finishes or is manually stopped.
 *  Will not be called when time is set directly.
 *
 *  @param animator The animator for which the animation ended.
 */
- (void)tweenAnimatorDidFinishAnimating:(RZTweenAnimator *)animator;

@end
