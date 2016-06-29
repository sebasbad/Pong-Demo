//
//  GameScene.m
//  Pong Demo
//
//  Created by Sebastián Badea on 27/5/16.
//  Copyright (c) 2016 Sebastian Badea. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()

@property (strong, nonatomic) UITouch *leftPaddleMotivatingTouch;
@property (strong, nonatomic) UITouch *rightPaddleMotivatingTouch;

@end

@implementation GameScene

static const CGFloat kTrackPixelsPerSecond = 1000;

-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    SKNode *ball = [self childNodeWithName:@"ball"];
    ball.physicsBody.angularVelocity = 1.0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        NSLog(@"\n%f %f %f %f", location.x, location.y, self.frame.size.width, self.frame.size.height);
        
        if (location.x < self.frame.size.width * 0.3) {
            self.leftPaddleMotivatingTouch = touch;
            NSLog(@"left");
        } else if (location.x > self.frame.size.width * 0.7) {
            self.rightPaddleMotivatingTouch = touch;
            NSLog(@"right");
        } else {
            SKNode *ball = [self childNodeWithName:@"ball"];
            ball.physicsBody.velocity = CGVectorMake(ball.physicsBody.velocity.dx * 2.0, ball.physicsBody.velocity.dy);
        }
    }
    
    [self trackPaddlesToMotivatingTouches];
}

- (void)trackPaddlesToMotivatingTouches {
    
    id nodeAndTouchArray = @[@{@"node": [self childNodeWithName:@"left_paddle"],
                               @"touch": self.leftPaddleMotivatingTouch ?: [NSNull null]
                               },
                             @{@"node": [self childNodeWithName:@"right_paddle"],
                               @"touch": self.rightPaddleMotivatingTouch ?: [NSNull null]
                               }];
    
    for (NSDictionary *nodeAndTouch in nodeAndTouchArray) {
        SKNode *node = nodeAndTouch[@"node"];
        UITouch *touch = nodeAndTouch[@"touch"];
        
        if ([[NSNull null] isEqual:touch]) {
            continue;
        }
        
        CGFloat yPos = [touch locationInNode:self].y;
        NSTimeInterval duration = ABS(yPos - node.position.y) / kTrackPixelsPerSecond;
        
        SKAction *moveAction = [SKAction moveToY:yPos duration:duration];
        [node runAction:moveAction withKey:@"moving!"];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
