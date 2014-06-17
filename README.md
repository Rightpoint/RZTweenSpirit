RZTweenSpirit
=============

[![Build Status](https://travis-ci.org/Raizlabs/RZTweenSpirit.svg)](https://travis-ci.org/Raizlabs/RZTweenSpirit)

## Overview

RZTweenSpirit is an iOS library for piecewise, timeline-based tweening of arbitrary data. What's tweening?

>Inbetweening or **tweening** is the process of generating intermediate frames between two images to give the appearance that the first image evolves smoothly into the second image. Inbetweens are the drawings between the key frames which help to create the illusion of motion. Inbetweening is a key process in all types of animation, including computer animation.
>
> Wikipedia

RZTweenSpirit is great for scripting animation timelines, but it can also do much more.

Let's see a simple example:

```
// Create an animator
RZTweenAnimator *tweenAnimator = [[RZTweenAnimator alloc] init];

// Use a float tween to animate the opacity of a label from 0 to 1 over 10 seconds with an eased-out curve
RZFloatTween *labelAlpha = [[RZFloatTween alloc] initWithCurveType:RZTweenCurveTypeSineEaseOut];
[labelAlpha addKeyFloat:0.0 atTime:0.0];
[labelAlpha addKeyFloat:1.0 atTime:10.0];
[tweenAnimator addTween:arrowAlpha forKeyPath:@"alpha" ofObject:self.titleLabel];

// Use a point tween to animate the center of the label from one point to another with a linear curve
RZPointTween *labelCenter = [[RZPointTween alloc] initWithCurveType:RZTweenCurveTypeLinear];
[labelCenter addKeyPoint:CGPointMake(100, 100) atTime:0.0];
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

In many cases, CoreAnimation is probably a better choice than RZTweenSpirit. If you're performing one-shot animations with complex curves, chaining animations together, CoreAnimation is definitely the way to go.

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

RZTweenSpirit not only has the ability to produce intermediate values of any datatype you wish, at any point along a timeline. The primary use case is for scripting complex animation timelines in response to some form of progression, such as a user scrolling through an onboarding flow or a file being downloaded. However, RZTweenSpirit's dynamic API allows you to setup tweening for *any* object or data type you can think of.

### Getting Started

First, import the `RZTweenSpirit.h` header.

### Full Documentation

For more complete documentation, see the [CocoaDocs]() page and the example project.

## License

RZTweenSpirit is licensed under the MIT license. See `LICENSE` for details.
