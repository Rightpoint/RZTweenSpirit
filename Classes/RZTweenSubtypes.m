//
//  RZTweenSubtypes.m
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

#import "RZTweenSubtypes.h"

static float RZTweenClampFloat(float value, float min, float max)
{
    return MIN(max, MAX(value, min));
}

static float RZTweenQuadraticEaseIn(float v)
{
	return powf(v, 2);
}

static float RZTweenQuadraticEaseOut(float v)
{
	return -(v * (v - 2));
}

static float RZTweenQuadraticEaseInOut(float v)
{
    float ret;
	if(v < 0.5)
	{
		ret = 2 * powf(v, 2);
	}
	else
	{
		ret = (-2 * powf(v, 2)) + (4 * v) - 1;
	}
    return ret;
}

static float RZTweenSineEaseIn(float v)
{
	return sin(M_PI_2 * (v - 1)) + 1;
}

static float RZTweenSineEaseOut(float v)
{
	return sin(M_PI_2 * v);
}

static float RZTweenSineEaseInOut(float v)
{
	return (1 - cos(M_PI * v))/2;
}

static float RZTweenEasedDelta(float delta, RZTweenCurveType curve)
{
    float result = 0.0f;
    
    switch (curve) {
        case RZTweenCurveTypeLinear:
            result = delta;
            break;
        case RZTweenCurveTypeQuadraticEaseIn:
            result = RZTweenQuadraticEaseIn(delta);
            break;
        case RZTweenCurveTypeQuadraticEaseOut:
            result = RZTweenQuadraticEaseOut(delta);
            break;
        case RZTweenCurveTypeQuadraticEaseInOut:
            result = RZTweenQuadraticEaseInOut(delta);
            break;
        case RZTweenCurveTypeSineEaseIn:
            result = RZTweenSineEaseIn(delta);
            break;
        case RZTweenCurveTypeSineEaseOut:
            result = RZTweenSineEaseOut(delta);
            break;
        case RZTweenCurveTypeSineEaseInOut:
            result = RZTweenSineEaseInOut(delta);
            break;
        default:
            result = delta;
            break;
    }
    
    return result;
}

static float RZTweenLerp(float delta, float inMin, float inMax, float outMin, float outMax)
{
    float result = delta * (outMax - outMin) + outMin;
    return RZTweenClampFloat(result, MIN(outMin,outMax), MAX(outMin,outMax));
}


// -----------------------------

@interface RZTKeyFrame : NSObject

@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, strong) NSValue *value;

+ (instancetype)keyFrameWithTime:(NSTimeInterval)time value:(NSValue *)value;

@end

@implementation RZTKeyFrame

+ (instancetype)keyFrameWithTime:(NSTimeInterval)time value:(NSValue *)value
{
    RZTKeyFrame *kf = [RZTKeyFrame new];
    kf.time = time;
    kf.value = value;
    return kf;
}


- (BOOL)isEqual:(id)object
{
    if ( object == self ) {
        return YES;
    }
    
    if ( ![object isKindOfClass:[RZTKeyFrame class]] ) {
        return NO;
    }
    
    RZTKeyFrame *otherKeyframe = object;
    return ( [otherKeyframe.value isEqual:self.value] && otherKeyframe.time == self.time );
}

- (NSUInteger)hash
{
    return [self.value hash] ^ [@(self.time) hash];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"%@ - time:%f value:%@", [super debugDescription], self.time, self.value];
}

@end

// -----------------------------


@interface RZKeyFrameTween ()

@property (nonatomic, readwrite, assign) RZTweenCurveType curveType;
@property (nonatomic, strong) NSMutableArray *sortedKeyFrames;

@end

@implementation RZKeyFrameTween

- (instancetype)init
{
    return [self initWithCurveType:RZTweenCurveTypeLinear];
}

- (instancetype)initWithCurveType:(RZTweenCurveType)curveType
{
    self = [super init];
    if ( self ) {
        _curveType = curveType;
        _sortedKeyFrames = [NSMutableArray array];
    }
    return self;
}

- (NSValue *)tweenedValueAtTime:(NSTimeInterval)time
{
    NSValue *value = nil;
    NSArray *nearestKeyFrames = [self nearestKeyFramesForTime:time];
    if (nearestKeyFrames.count > 0)
    {
        if (nearestKeyFrames.count == 1)
        {
            RZTKeyFrame *kf = [nearestKeyFrames firstObject];
            value = kf.value;
        }
        else
        {
            RZTKeyFrame *kf1 = [nearestKeyFrames firstObject];
            RZTKeyFrame *kf2 = [nearestKeyFrames lastObject];
            double delta = (time - kf1.time) / (kf2.time - kf1.time);
            value = [self interpolatedValueFromKeyValue:kf1.value
                                                 atTime:kf1.time
                                             toKeyValue:kf2.value
                                                 atTime:kf2.time
                                              withDelta:RZTweenEasedDelta(delta, self.curveType)];
        }
    }
    return value;
}


- (void)addKeyValue:(NSValue *)value atTime:(NSTimeInterval)time
{
    NSParameterAssert(value);
    
    RZTKeyFrame *keyFrame = [RZTKeyFrame keyFrameWithTime:time value:value];
    
    if (self.sortedKeyFrames.count == 0)
    {
        [self.sortedKeyFrames addObject:keyFrame];
    }
    else
    {
        NSUInteger newIndex = [self.sortedKeyFrames indexOfObject:keyFrame
                                                    inSortedRange:NSMakeRange(0, self.sortedKeyFrames.count)
                                                          options:NSBinarySearchingInsertionIndex
                                                  usingComparator:^NSComparisonResult(RZTKeyFrame *kf1, RZTKeyFrame *kf2) {
                                                      return [@(kf1.time) compare:@(kf2.time)];
                                                  }];
        [self.sortedKeyFrames insertObject:keyFrame atIndex:newIndex];
    }
}

#pragma mark - Private

- (NSValue *)interpolatedValueFromKeyValue:(NSValue *)fromValue atTime:(NSTimeInterval)fromTime toKeyValue:(NSValue *)toValue atTime:(NSTimeInterval)toTime withDelta:(float)delta
{
    NSString *exceptionString = [NSString stringWithFormat:@"Cannot use RZKeyFrameTween directly - must subclass and override %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:exceptionString userInfo:nil];
}

- (NSArray *)nearestKeyFramesForTime:(NSTimeInterval)time
{
    NSArray *kframes = nil;
    if (self.sortedKeyFrames.count > 0)
    {
        RZTKeyFrame *searchFrame = [RZTKeyFrame keyFrameWithTime:time value:nil];
        NSUInteger insertIndex = [self.sortedKeyFrames indexOfObject:searchFrame
                                                       inSortedRange:NSMakeRange(0, self.sortedKeyFrames.count)
                                                             options:NSBinarySearchingInsertionIndex
                                                     usingComparator:^NSComparisonResult(RZTKeyFrame *kf1, RZTKeyFrame *kf2) {
                                                         return [@(kf1.time) compare:@(kf2.time)];
                                                     }];
        
        if (insertIndex == 0)
        {
            kframes = @[[self.sortedKeyFrames firstObject]];
        }
        else if (insertIndex == self.sortedKeyFrames.count)
        {
            kframes = @[[self.sortedKeyFrames lastObject]];
        }
        else
        {
            kframes = @[[self.sortedKeyFrames objectAtIndex:insertIndex-1],
                        [self.sortedKeyFrames objectAtIndex:insertIndex]];
        }
    }
    return kframes;
}

- (id)copyWithZone:(NSZone *)zone
{
    RZKeyFrameTween *copy = [[[self class] allocWithZone:zone] init];
    
    if (copy != nil) {
        copy.sortedKeyFrames = [self.sortedKeyFrames copy];
        copy.curveType = self.curveType;
    }
    
    return copy;
}

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    if ( ![object isMemberOfClass:[self class]] ) {
        return NO;
    }
    
    return [self isEqualToTween:object];
}

- (BOOL)isEqualToTween:(id<RZTween>)tween
{
    if ( ![tween isKindOfClass:[RZKeyFrameTween class]] ) {
        return NO;
    }
    
    RZKeyFrameTween *kfTween = tween;
    return [self.sortedKeyFrames isEqualToArray:kfTween.sortedKeyFrames];
}

- (NSUInteger)hash {
    return [NSStringFromClass([self class]) hash] ^ [self.sortedKeyFrames hash];
}

@end

// -----------------------------

@implementation RZFloatTween

- (void)addKeyFloat:(CGFloat)keyFloat atTime:(NSTimeInterval)time
{
    [self addKeyValue:@(keyFloat) atTime:time];
}

- (NSValue *)interpolatedValueFromKeyValue:(NSValue *)fromValue atTime:(NSTimeInterval)fromTime toKeyValue:(NSValue *)toValue atTime:(NSTimeInterval)toTime withDelta:(float)delta
{
    return @(RZTweenLerp(delta, fromTime, toTime, [(NSNumber *)fromValue floatValue], [(NSNumber *)toValue floatValue]));
}

@end

// -----------------------------

@implementation RZBooleanTween

- (void)addKeyBool:(BOOL)keyBool atTime:(NSTimeInterval)time
{
    [self addKeyValue:@(keyBool) atTime:time];
}

- (NSValue *)interpolatedValueFromKeyValue:(NSValue *)fromValue atTime:(NSTimeInterval)fromTime toKeyValue:(NSValue *)toValue atTime:(NSTimeInterval)toTime withDelta:(float)delta
{
    return fromValue;
}

@end

// -----------------------------

@implementation RZTransformTween

- (void)addKeyTransform:(CGAffineTransform)transform atTime:(NSTimeInterval)time
{
    [self addKeyValue:[NSValue valueWithCGAffineTransform:transform] atTime:time];
}

- (NSValue *)interpolatedValueFromKeyValue:(NSValue *)fromValue atTime:(NSTimeInterval)fromTime toKeyValue:(NSValue *)toValue atTime:(NSTimeInterval)toTime withDelta:(float)delta
{
    CGAffineTransform tf1 = [fromValue CGAffineTransformValue];
    CGAffineTransform tf2 = [toValue CGAffineTransformValue];

    CGAffineTransform finalTf;
    finalTf.a = RZTweenLerp(delta, fromTime, toTime, tf1.a, tf2.a);
    finalTf.b = RZTweenLerp(delta, fromTime, toTime, tf1.b, tf2.b);
    finalTf.c = RZTweenLerp(delta, fromTime, toTime, tf1.c, tf2.c);
    finalTf.d = RZTweenLerp(delta, fromTime, toTime, tf1.d, tf2.d);
    finalTf.tx = RZTweenLerp(delta, fromTime, toTime, tf1.tx, tf2.tx);
    finalTf.ty = RZTweenLerp(delta, fromTime, toTime, tf1.ty, tf2.ty);

    return [NSValue valueWithCGAffineTransform:finalTf];
}

@end

@implementation RZRectTween

- (void)addKeyRect:(CGRect)rect atTime:(NSTimeInterval)time
{
    [self addKeyValue:[NSValue valueWithCGRect:rect] atTime:time];
}

- (NSValue *)interpolatedValueFromKeyValue:(NSValue *)fromValue atTime:(NSTimeInterval)fromTime toKeyValue:(NSValue *)toValue atTime:(NSTimeInterval)toTime withDelta:(float)delta
{
    CGRect rect1 = [fromValue CGRectValue];
    CGRect rect2 = [toValue CGRectValue];

    CGRect finalRect;
    finalRect.origin.x      = RZTweenLerp(delta, fromTime, toTime, rect1.origin.x, rect2.origin.x);
    finalRect.origin.y      = RZTweenLerp(delta, fromTime, toTime, rect1.origin.y, rect2.origin.y);
    finalRect.size.width    = RZTweenLerp(delta, fromTime, toTime, rect1.size.width, rect2.size.width);
    finalRect.size.height   = RZTweenLerp(delta, fromTime, toTime, rect1.size.height, rect2.size.height);

    return [NSValue valueWithCGRect:finalRect];
}

@end

@implementation RZPointTween

- (void)addKeyPoint:(CGPoint)point atTime:(NSTimeInterval)time
{
    [self addKeyValue:[NSValue valueWithCGPoint:point] atTime:time];
}

- (NSValue *)interpolatedValueFromKeyValue:(NSValue *)fromValue atTime:(NSTimeInterval)fromTime toKeyValue:(NSValue *)toValue atTime:(NSTimeInterval)toTime withDelta:(float)delta
{
    CGPoint p1 = [fromValue CGPointValue];
    CGPoint p2 = [toValue CGPointValue];

    CGPoint finalPoint;
    finalPoint.x = RZTweenLerp(delta, fromTime, toTime, p1.x, p2.x);
    finalPoint.y = RZTweenLerp(delta, fromTime, toTime, p1.y, p2.y);

    return [NSValue valueWithCGPoint:finalPoint];
}

@end