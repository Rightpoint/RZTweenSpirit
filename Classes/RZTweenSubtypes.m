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

static float RZTweenMapFloat(float value, float inMin, float inMax, float outMin, float outMax, BOOL clamp, RZTweenCurveType curve)
{
    float result;
    
    float normalizedValue = (value - inMin) / (inMax - inMin);
    
    switch (curve) {
        case RZTweenCurveTypeLinear:
            result = normalizedValue;
            break;
        case RZTweenCurveTypeQuadraticEaseIn:
            result = RZTweenQuadraticEaseIn(normalizedValue);
            break;
        case RZTweenCurveTypeQuadraticEaseOut:
            result = RZTweenQuadraticEaseOut(normalizedValue);
            break;
        case RZTweenCurveTypeQuadraticEaseInOut:
            result = RZTweenQuadraticEaseInOut(normalizedValue);
            break;
        case RZTweenCurveTypeSineEaseIn:
            result = RZTweenSineEaseIn(normalizedValue);
            break;
        case RZTweenCurveTypeSineEaseOut:
            result = RZTweenSineEaseOut(normalizedValue);
            break;
        case RZTweenCurveTypeSineEaseInOut:
            result = RZTweenSineEaseInOut(normalizedValue);
            break;
        default:
            result = normalizedValue;
            break;
    }
    
    result = result * (outMax - outMin) + outMin;
    
    if (clamp)
    {
        result = RZTweenClampFloat(result, MIN(outMin,outMax), MAX(outMin,outMax));
    }
    
    return result;
}


// -----------------------------

@interface RZTKeyFrame : NSObject

+ (instancetype)keyFrameWithTime:(NSTimeInterval)time value:(NSValue *)value;

@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, strong) NSValue *value;

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
    return [NSString stringWithFormat:@"%@ - time:%f value:%@",[super debugDescription], self.time, self.value];
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

- (NSValue *)valueAtTime:(NSTimeInterval)time
{
    return @0;
}


- (void)addKeyFrameWithValue:(NSValue *)value atTime:(NSTimeInterval)time
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
    [self addKeyFrameWithValue:@(keyFloat) atTime:time];
}


- (NSValue*)valueAtTime:(NSTimeInterval)time
{
    NSNumber *value = @0;
    NSArray *nearestKeyFrames = [self nearestKeyFramesForTime:time];
    if (nearestKeyFrames.count > 0)
    {
        if (nearestKeyFrames.count == 1)
        {
            RZTKeyFrame *kf = [nearestKeyFrames firstObject];
            value = (NSNumber*)kf.value;
        }
        else
        {
            RZTKeyFrame *kf1 = [nearestKeyFrames firstObject];
            RZTKeyFrame *kf2 = [nearestKeyFrames lastObject];
            value = @(RZTweenMapFloat(time, kf1.time, kf2.time, [(NSNumber*)kf1.value floatValue], [(NSNumber*)kf2.value floatValue], YES, self.curveType));
        }
    }
    return value;
}

@end

// -----------------------------

@implementation RZBooleanTween

- (void)addKeyBool:(BOOL)keyBool atTime:(NSTimeInterval)time
{
    [self addKeyFrameWithValue:@(keyBool) atTime:time];
}


- (NSValue*)valueAtTime:(NSTimeInterval)time
{
    NSNumber *value = @0;
    NSArray *nearestKeyFrames = [self nearestKeyFramesForTime:time];
    if (nearestKeyFrames.count > 0) {
        RZTKeyFrame *kf = [nearestKeyFrames firstObject];
        value = (NSNumber*)kf.value;
    }
    return value;
}

@end

// -----------------------------

@implementation RZTransformTween

- (void)addKeyTransform:(CGAffineTransform)transform atTime:(NSTimeInterval)time
{
    [self addKeyFrameWithValue:[NSValue valueWithCGAffineTransform:transform] atTime:time];
}


- (NSValue*)valueAtTime:(NSTimeInterval)time
{
    NSValue *transformValue = [NSValue valueWithCGAffineTransform:CGAffineTransformIdentity];
    NSArray *nearestKeyFrames = [self nearestKeyFramesForTime:time];
    if (nearestKeyFrames.count > 0)
    {
        if (nearestKeyFrames.count == 1)
        {
            RZTKeyFrame *kf = [nearestKeyFrames firstObject];
            transformValue = kf.value;
        }
        else
        {
            RZTKeyFrame *kf1 = [nearestKeyFrames firstObject];
            RZTKeyFrame *kf2 = [nearestKeyFrames lastObject];
            
            CGAffineTransform tf1 = [kf1.value CGAffineTransformValue];
            CGAffineTransform tf2 = [kf2.value CGAffineTransformValue];
            
            CGAffineTransform finalTf;
            finalTf.a = RZTweenMapFloat(time, kf1.time, kf2.time, tf1.a, tf2.a, YES, self.curveType);
            finalTf.b = RZTweenMapFloat(time, kf1.time, kf2.time, tf1.b, tf2.b, YES, self.curveType);
            finalTf.c = RZTweenMapFloat(time, kf1.time, kf2.time, tf1.c, tf2.c, YES, self.curveType);
            finalTf.d = RZTweenMapFloat(time, kf1.time, kf2.time, tf1.d, tf2.d, YES, self.curveType);
            finalTf.tx = RZTweenMapFloat(time, kf1.time, kf2.time, tf1.tx, tf2.tx, YES, self.curveType);
            finalTf.ty = RZTweenMapFloat(time, kf1.time, kf2.time, tf1.ty, tf2.ty, YES, self.curveType);
            
            transformValue = [NSValue valueWithCGAffineTransform:finalTf];
        }
    }
    return transformValue;
}

@end

@implementation RZRectTween

- (void)addKeyRect:(CGRect)rect atTime:(NSTimeInterval)time
{
    [self addKeyFrameWithValue:[NSValue valueWithCGRect:rect] atTime:time];
}

- (NSValue *)valueAtTime:(NSTimeInterval)time
{
    NSValue *rectValue = [NSValue valueWithCGRect:CGRectZero];
    NSArray *nearestKeyFrames = [self nearestKeyFramesForTime:time];
    if (nearestKeyFrames.count > 0)
    {
        if (nearestKeyFrames.count == 1)
        {
            RZTKeyFrame *kf = [nearestKeyFrames firstObject];
            rectValue = kf.value;
        }
        else
        {
            RZTKeyFrame *kf1 = [nearestKeyFrames firstObject];
            RZTKeyFrame *kf2 = [nearestKeyFrames lastObject];
            
            CGRect rect1 = [kf1.value CGRectValue];
            CGRect rect2 = [kf2.value CGRectValue];
            
            CGRect finalRect;
            finalRect.origin.x = RZTweenMapFloat(time, kf1.time, kf2.time, rect1.origin.x, rect2.origin.x, YES, self.curveType);
            finalRect.origin.y = RZTweenMapFloat(time, kf1.time, kf2.time, rect1.origin.y, rect2.origin.y, YES, self.curveType);
            finalRect.size.width = RZTweenMapFloat(time, kf1.time, kf2.time, rect1.size.width, rect2.size.width, YES, self.curveType);
            finalRect.size.height = RZTweenMapFloat(time, kf1.time, kf2.time, rect1.size.height, rect2.size.height, YES, self.curveType);
            
            rectValue = [NSValue valueWithCGRect:finalRect];
        }
    }
    return rectValue;
}

@end

@implementation RZPointTween

- (void)addKeyPoint:(CGPoint)point atTime:(NSTimeInterval)time
{
    [self addKeyFrameWithValue:[NSValue valueWithCGPoint:point] atTime:time];
}

- (NSValue *)valueAtTime:(NSTimeInterval)time
{
    NSValue *pointValue = [NSValue valueWithCGPoint:CGPointZero];
    NSArray *nearestKeyFrames = [self nearestKeyFramesForTime:time];
    if (nearestKeyFrames.count > 0)
    {
        if (nearestKeyFrames.count == 1)
        {
            RZTKeyFrame *kf = [nearestKeyFrames firstObject];
            pointValue = kf.value;
        }
        else
        {
            RZTKeyFrame *kf1 = [nearestKeyFrames firstObject];
            RZTKeyFrame *kf2 = [nearestKeyFrames lastObject];
            
            CGPoint p1 = [kf1.value CGPointValue];
            CGPoint p2 = [kf2.value CGPointValue];
            
            CGPoint finalPoint;
            finalPoint.x = RZTweenMapFloat(time, kf1.time, kf2.time, p1.x, p2.x, YES, self.curveType);
            finalPoint.y = RZTweenMapFloat(time, kf1.time, kf2.time, p1.y, p2.y, YES, self.curveType);
            
            pointValue = [NSValue valueWithCGPoint:finalPoint];
        }
    }
    return pointValue;
}

@end