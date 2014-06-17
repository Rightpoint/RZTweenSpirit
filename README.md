RZTweenSpirit
=============




## Overview

RZTweenSpirit is an iOS library for piecewise, timeline-based tweening of arbitrary data. What's tweening?

>Inbetweening or **tweening** is the process of generating intermediate frames between two images to give the appearance that the first image evolves smoothly into the second image. Inbetweens are the drawings between the key frames which help to create the illusion of motion. Inbetweening is a key process in all types of animation, including computer animation.
>
> Wikipedia

RZTweenSpirit is great for scripting animation timelines, but it can also do much more.

Let's see a simple example:

```objc

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
