//
//  fraPlayer.m
//  Frankenstein
//
//  Created by Trenton Maki on 5/20/14.
//  Copyright (c) 2014 Trenton Maki. All rights reserved.
//

#import "fraPlayer.h"
#import "SKTUtils.h"

@interface Player()
@property (nonatomic, assign) CGPoint GRAVITY;
@property (nonatomic, assign) NSInteger X_LIMIT;
@property (nonatomic, assign) NSInteger Y_LIMIT;
@property (nonatomic, assign) NSInteger CHANGE_IN_BOUNDING_BOX_X;//Changes the bounding
@property (nonatomic, assign) NSInteger CHANGE_IN_BOUNDING_BOX_Y;//box by this number of points
@end                                                             //(on both sides)

@implementation Player
+(id)createPlayer{
    return [[self alloc] initPlayer];
}

-(id)initPlayer
{
    self = [super initWithImageNamed:@"mouse_1.png"];
    if (self) {
        self.GRAVITY = CGPointMake(0.0, -450.0);//Change in y over 1 second
        self.X_LIMIT = 700; //Maximum change in x/y
        self.Y_LIMIT = 700;
        self.velocity = CGPointMake(0.0, 0.0);
        self.CHANGE_IN_BOUNDING_BOX_X = 0;
        self.CHANGE_IN_BOUNDING_BOX_Y = 0;
    }
    return self;
}

- (void)update:(NSTimeInterval)delta {
    [self update:delta withGravity:self.GRAVITY];
}

- (void)update:(NSTimeInterval)delta withGravity:(CGPoint) gravity{
            NSLog(@"Update! (player)");
    CGPoint gravityStep = CGPointMultiplyScalar(gravity, delta);
    self.velocity = CGPointAdd(self.velocity, gravityStep);
    CGPoint velocityStep = CGPointMultiplyScalar(self.velocity, delta); //Keeping it in line
    
    velocityStep.x = MIN(velocityStep.x, self.X_LIMIT);//Applying the brakes
    velocityStep.y = MIN(velocityStep.y, self.Y_LIMIT);
    velocityStep.x = MAX(velocityStep.x, self.X_LIMIT);
    velocityStep.y = MAX(velocityStep.y, self.Y_LIMIT);
    
    self.desiredPosition = CGPointAdd(self.position, velocityStep);
}

- (CGRect)collisionBoundingBox {
    CGRect boundingBox = CGRectInset(self.frame, self.CHANGE_IN_BOUNDING_BOX_X, self.CHANGE_IN_BOUNDING_BOX_Y);
    CGPoint diff = CGPointSubtract(self.desiredPosition, self.position);
    return CGRectOffset(boundingBox, diff.x, diff.y);
}

@end
