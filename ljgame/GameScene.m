//
//  GameScene.m
//  ljgame
//
//  Created by Zonggao Jia on 2015-08-26.
//  Copyright (c) 2015 Zonggao Jia. All rights reserved.
//

#import "GameScene.h"

int gameStatus = 0;
bool isTouching = false;
bool isWin = false;
bool shooted = false;
static const uint32_t ballCategory   = 0x1;      // 00000000000000000000000000000001
static const uint32_t playerCategory  = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t enemyCategory = 0x1 << 2; // 00000000000000000000000000000100
static const uint32_t edgeCategory   = 0x1 << 3; // 00000000000000000000000000001000

@implementation GameScene

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor whiteColor];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask = edgeCategory;
        
        // change gravity settings of the physics world
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    [self resetView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if (gameStatus == 0) {
        gameStatus = 1;
        shooted = false;
        // remove label
        [[self childNodeWithName: @"myLabel"] removeFromParent];
        //game start
        
        //add player
        SKSpriteNode *player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
        player.position = CGPointMake(50.0f, 80.0f);
        player.name = @"thePlayer";
        player.zPosition = 0;
        player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.frame.size.width / 2];
        player.physicsBody.categoryBitMask = playerCategory;
        player.physicsBody.dynamic =  NO;
        [self addChild:player];
        
        //add enemies
        SKSpriteNode *enemy1 = [SKSpriteNode spriteNodeWithImageNamed:@"enemy"];
        enemy1.position = CGPointMake(550.0f, 80.0f);
        enemy1.name = @"theEnemy";
        enemy1.zPosition = 0;
        enemy1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:enemy1.frame.size.width / 2];
        enemy1.physicsBody.categoryBitMask = enemyCategory;
        enemy1.physicsBody.dynamic =  NO;
        [self addChild:enemy1];
        //move enemy along a line
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, enemy1.position.x, enemy1.position.y);
        CGPathAddLineToPoint(path, nil, enemy1.position.x, enemy1.position.y + 200);
        SKAction *followline = [SKAction followPath:path asOffset:NO orientToPath:NO duration:3.0];
        SKAction *reversedLine = [followline reversedAction];
        [enemy1 runAction:[SKAction repeatActionForever: [SKAction sequence: @[followline, reversedLine]]] withKey: @"enemyMoveAlongLine"];
        
        //add ball
        SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"snowball"];
        ball.position = CGPointMake(80.0f, 80.0f);
        ball.name = @"theBall";
        ball.zPosition = 1;
        [self addChild:ball];
    } else {
        isTouching = true;
        
        [self drawAimline: touches];
    }
}

-(void)resetView {
    [self removeAllChildren];
    gameStatus = 0;
    isTouching = false;
    /* Setup your scene here */
    //setup background image
    SKSpriteNode *sn = [SKSpriteNode spriteNodeWithImageNamed:@"LaunchScreen"];
    sn.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    sn.name = @"BACKGROUND";
    sn.zPosition = -1;
    [self addChild:sn];
    
    //add 'tap to begin...' label
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    if (isWin)
        myLabel.text = @"Yeah, you win!!!!!";
    else
        myLabel.text = @"Tap to begin ...";
    isWin = false;
    myLabel.fontColor = [SKColor grayColor];
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) / 3);
    [myLabel setName:@"myLabel"];
    [self addChild:myLabel];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (isTouching) {
        isTouching = false;
        // Remove aim line if there was one
        [[self childNodeWithName: @"myAimLine"] removeFromParent];
        
        // Find the ball
        SKSpriteNode *ball = (SKSpriteNode*)[self childNodeWithName: @"theBall"];
        // Add a VOLUME based physics body to the ball
        ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width];
        ball.physicsBody.categoryBitMask = ballCategory;
        //ball.physicsBody.friction = 0;
        ball.physicsBody.linearDamping = 0;
        ball.physicsBody.restitution = 0.5f;
        ball.physicsBody.contactTestBitMask = playerCategory | enemyCategory | edgeCategory;
        
        UITouch *touch = [touches anyObject];
        CGPoint positionInScene = [touch locationInNode:self];
        CGVector vector = CGVectorMake((positionInScene.x - ball.position.x) / 25, (positionInScene.y - ball.position.y) / 25);
        // now give a push on the ball
        [ball.physicsBody applyImpulse: vector];
        
        shooted = true;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(isTouching && !shooted){
        // Remove aim line if there was one
        [[self childNodeWithName: @"myAimLine"] removeFromParent];
        
        [self drawAimline: touches];
    }
}

-(void)drawAimline:(NSSet *)touches {
    // Find the ball
    SKSpriteNode *ball = (SKSpriteNode*)[self  childNodeWithName: @"theBall"];
    // Get tap position
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    //draw aim line.
    SKShapeNode *aimline = [SKShapeNode node];
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, ball.position.x, ball.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, positionInScene.x, positionInScene.y);
    aimline.path = pathToDraw;
    aimline.lineWidth = 3;
    [aimline setStrokeColor:[UIColor redColor]];
    [aimline setName:@"myAimLine"];
    [self addChild:aimline];
}

-(void)update:(CFTimeInterval)currentTime {
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    // create placeholder reference for the "non ball" object
    SKPhysicsBody *notTheBall;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        notTheBall = contact.bodyB;
    } else {
        notTheBall = contact.bodyA;
    }
    
    if (notTheBall.categoryBitMask == playerCategory) {
        //  SKAction *playSFX = [SKAction playSoundFileNamed:@"brickhit.caf" waitForCompletion:NO];
        // [self runAction:playSFX];
        //[notTheBall.node removeFromParent];
    }
    
    if (notTheBall.categoryBitMask == enemyCategory) {
        // SKAction *playSFX = [SKAction playSoundFileNamed:@"blip.caf" waitForCompletion:NO];
        //  [self runAction:playSFX];
        //rotate enemy
        SKSpriteNode *enemy1 = (SKSpriteNode*)[self childNodeWithName: @"theEnemy"];
        [enemy1 removeActionForKey:@"enemyMoveAlongLine"];
        SKAction * rotation = [SKAction rotateByAngle:40.0f duration:.5f];
        SKAction * doRotation = [SKAction repeatActionForever:rotation];
        [enemy1 runAction:doRotation];
        isWin = true;
    }
    
    if (notTheBall.categoryBitMask == edgeCategory) {
        [self resetView];
    }
    
}

@end
