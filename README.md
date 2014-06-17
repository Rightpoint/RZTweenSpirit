RZTweenSpirit
=============

[![Build Status](https://travis-ci.org/Raizlabs/RZTweenSpirit.svg)](https://travis-ci.org/Raizlabs/RZTweenSpirit)

<p align="center">
<img src="https://raw.githubusercontent.com/Raizlabs/RZTweenSpirit/readme-assets/screencap_optimized.gif" alt="RZTweenSpirit">
</p>

## Overview

RZTweenSpirit is an iOS library for piecewise, timeline-based tweening of values, which is particularly useful for animation timelines.

**What's tweening?**

>Inbetweening or **tweening** is the process of generating intermediate frames between two images to give the appearance that the first image evolves smoothly into the second image. Inbetweens are the drawings between the key frames which help to create the illusion of motion. Inbetweening is a key process in all types of animation, including computer animation.
>
> Wikipedia

RZTweenSpirit is great for scripting animation timelines, but it can also do much more.

Let's see a simple example:

```objective-c
// Create an animator
RZTweenAnimator *tweenAnimator = [[RZTweenAnimator alloc] init];

// Use a float tween to animate the opacity of a label from 0 to 1 over 10 seconds with an eased-out curve
RZFloatTween *labelAlpha = [[RZFloatTween alloc] initWithCurveType:RZTweenCurveTypeSineEaseOut];
[labelAlpha addKeyFloat:0.0 atTime:0.0];
[labelAlpha addKeyFloat:1.0 atTime:10.0];
[tweenAnimator addTween:arrowAlpha forKeyPath:@"alpha" ofObject:self.titleLabel];

// Use a point tween to animate the center of the label between three points with a linear curve
RZPointTween *labelCenter = [[RZPointTween alloc] initWithCurveType:RZTweenCurveTypeLinear];
[labelCenter addKeyPoint:CGPointMake(100, 100) atTime:0.0];
[labelCenter addKEyPoint:CGPointMake(400, 100) atTime:6.0];
[labelCenter addKeyPoint:CGpointMake(200, 400) atTime:10.0];
[tweenAnimator addTween:labelCenter forKeyPath@"center" ofObject:self.titleLabel];

// You can set the time on the animator directly to jump immediately to the corresponding values in the timeline
// This is super useful for "scrubbing" the timeline in response to, say, a scrollview being scrolled
[tweenAnimator setTime:0];

// You can animate the timeline from its current point to another point
[tweenAnimator animateToTime:10.0];

// You can also animate to another point in a specific duration.
// It helps to think of "time" as more of an offset along the timeline than a specific instant measured in seconds.
[tweenAnimator animateToTime:10.0 overDuration:20.0]; // (half speed if starting at 0)

```

#### Why not use CoreAnimation?

In many situations, CoreAnimation is probably a better choice than RZTweenSpirit. If you need a reliable, proven animation system, CoreAnimation is definitely the way to go. But if you're looking for a more expressive way to create animation timelines, you might find RZTweenSpirit useful!

## Requirements

RZTweenSpirit supports iOS 7.0+.

## Installation

#### CocoaPods (recommended)

Simply add the library to your podfile, optionally specifying a version number:

`pod 'RZTweenSpirit' '~> 0.1'`

RZTweenSpirit uses semantic versioning. Please check the README periodically for information about updates.

#### Manual Installation

Copy all of the files in the `Classes` directory to your project. Linking with `QuartzCore` is also required, but it should be implicit through the use of framework modules in the file headers.

## Documentation

### Getting Started

First, import the `RZTweenSpirit.h` header. Then, allocate and initialize an instance of `RZTweenAnimator`, and hold onto it in a property in your view controller or view:

```objective-c
self.tweenAnimator = [[RZTweenAnimator alloc] init];
```

That's it - you're ready to start making some tweens!

### Tweens

An object which implements the `RZTween` protocol (henceforth refered to as a "tween") simply has the ability to return a value for a particular point along a timeline. There are only two methods in the protocol:

- **`+ (Class)valueClass;`**
	- Returns the class represented by values produced by this tween. This can be used for type checking, as it is with `RZKeyFrameTween`.
- **`- (id)tweenedValueAtTime:(NSTimeInterval)time;`**
	- Return a value of the type returned by `valueClass` for the provided time.

Despite the name, tweens do not necessarily have to interpolate between different values. They can simply return a single value for a given range of time.
		
**Note:** Classes implementing `RZTween` must also implement `NSCopying` as they will be used as keys in an internal dictionary within the animator.

### Keyframe Tweens

The primary concrete implementation of `RZTween` provided is `RZKeyFrameTween`, which provides facilities for tweening between keyframe values of various types anchored to instants along the timeline, with optional easing curves. See `RZKeyFrameTweens.h` for several concrete subtypes corresponding to different data types:

- `RZFloatTween` : `CGFloat` (wrapped in `NSNumber`)
- `RZBooleanTween` : `BOOL` (wrapped in `NSNumber`)
- `RZRectTween` : `CGRect` (wrapped in `NSValue`)
- `RZPointTween` : `CGPoint` (wrapped in `NSValue`)
- `RZColorTween` : `UIColor`


### The Animator

The animator is an object which is used to manage a timeline which drives tweens. It can be used to asynchronously "scrub" the timeline by setting the time directly, or to animate from one point on the timeline to another.

Objects implementing `RZTween` are registered with the animator in one of two ways: KVC or block-based. 

The KVC method takes a keypath and an object for which the keypath will be modified:

```objective-c
[self.tweenAnimator addTween:myRectTween forKeypath:@"frame" ofObject:self.myView];
```

This also works with CALayer transform keypaths, which will still play nicely together when using seperate tweens:

```objective-c
// Tween which represents rotation angle (around z-axis) in radians
[self.tweenAnimator addTween:myRotationTween forKeypath:@"transform.rotation" ofObject:self.myView.layer];

// Tween which represents translation as a CGPoint
[self.tweenAnimator addTween:myTranslationTween forKeypath:@"transform.translation" ofObject:self.myView.layer];
```

The block-based method takes a block which will receive a reference to the tween itself and the current value of the tween:

```objective-c
// Must use a weak self reference within these blocks to avoid a retain cycle, 
// if the animator is retained by self.
__weak typeof(self) weakSelf = self;

// Note that the second argument of the block can be cast upwards from id 
// to whatever type the tween returns as a value
[self.tweenAnimator addTween:myTween withUpdateBlock:^(id<RZTween> tween, NSNumber *value) {
	weakSelf.someConstraint.constant = [value floatValue]; // must unbox NSNumber/NSValue
	NSLog(@"Updated constraint constant to: %@", value);
}];
```

Once you have some tweens registered, you can set the animator's time offset directly or animate it to a particular instant.

### Custom Tweens

Because the `RZTween` protocol and the entire RZTweenSpirit architecture is dynamically typed, you can make tweens for literally anything:

- Strings that need to populate a label at different points along a timeline
- Images that make up frames of an animated sequence
- More complex model objects representing some on-screen data

The possiblities are endless!

### Full Documentation

For more complete documentation, see the [CocoaDocs]() page. 

For working examples, see the example project.

## License

RZTweenSpirit is licensed under the MIT license. See `LICENSE` for details.
