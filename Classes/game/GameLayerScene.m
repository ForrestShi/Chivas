// Import the interfaces
#import "GameLayerScene.h"
#import "HUDLayer.h"
#import "Card.h"
#import "ChivasAppDelegate.h"
#import "LayoutParameters.h"
#import "ChivasAppDelegate.h"

// GameLayer implementation
@implementation GameLayer

@synthesize hud;
@synthesize deck;
@synthesize first_card;
@synthesize second_card;
@synthesize readyPlay;
@synthesize checkResultTimer;
@synthesize resultSprite;


//I do the setup for the scene inside the game layer 
+(id) scene
{
	CCScene *scene = [CCScene node];
	
	GameLayer *layer    = [GameLayer node];
	HUDLayer *hudlayer  = [HUDLayer node];
	CCSprite* background = [CCSprite spriteWithFile:@"matching-game-back.png"];
	//background image size w/2, h/2 
	background.position = ccp(CROP_BACK_W/2 ,CROP_BACK_H/2 );
		
	[layer setHud:hudlayer];
	[hudlayer setGame:layer];
	
	
	[scene addChild:hudlayer z:2];
	[scene addChild:layer    z:1];
	[scene addChild:background z:0];
	
	return scene;
}

-(id) init
{
	if( (self=[super init] )) {

		[self initializeDeck];
        [self shuffleDeck];
        [self dealDeck];
        
        first_card   = NULL;
        second_card  = NULL;
        in_match     = NO;
        score        = 0;
		
		isTouchEnabled = YES;
		// Standard method to create a button
		//CCMenuItem *backMenuItem = [CCMenuItemImage 
//									itemFromNormalImage:@"sand1.png" selectedImage:@"sand2.png" 
//									target:self selector:@selector(backButtonTapped:)];
//		backMenuItem.position = ccp(160, 160);
//		CCMenu *backMenu = [CCMenu menuWithItems:backMenuItem, nil];
//		backMenu.position = ccp(100,100);
//		
//		[self addChild:backMenu z:1];
		NSTimeInterval ti = 20;
		//checkResultTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 invocation:<#(NSInvocation *)invocation#> repeats:NO];
		checkResultTimer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(checkResult) userInfo:nil repeats:NO];
		
    }
    return self;
}

- (void) checkResult{
	if (score != 4) {
		//failed
		NSLog(@"FAILED");
		//[self unschedule:@selector(checkResult)];

		resultSprite = [CCSprite spriteWithFile:@"failure.png"];
		
		[resultSprite setPosition:ccp(CROP_BACK_W/2 ,CROP_BACK_H/2 )];
		[resultSprite setScale:0.6];
		[self addChild:resultSprite z:3];
		
		//do not allow press "Back button " now 
		//because that will trigger some issues
		//ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
//		[appDelegate enableBackButton:NO];
		
		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(backToCoverFlow) userInfo:nil repeats:NO];
	}
}

- (void) backToCoverFlow{
	//[self unschedule:@selector(backToCoverFlow)];

	ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate endMatchCardGame];
	
		
}
- (void) dealloc
{
	[resultSprite release];
	[checkResultTimer release];
	[super dealloc];
}

- (void) initializeDeck
{
    [self setDeck:[NSMutableArray arrayWithCapacity:DECK_SIZE]];
    for (int x = 1; x < DECK_SIZE/2 + 1; x++) {
        [deck addObject:[Card newFromValue:x]];
        [deck addObject:[Card newFromValue:x]];
    }
}

- (void) shuffleDeck
{
    in_match    = NO;
    first_card  = NULL;
    second_card = NULL;
    [self resetScore];
    
    // Cleaning up card states.
    for (int x = 0; x < DECK_SIZE; x++) {
        Card *testCard = [deck objectAtIndex:x];
        testCard.is_matched = NO;
        testCard.is_flipped = NO;
    }
    
    // Randomizing order.
    for (int x = 0; x < DECK_SIZE; x++) {
        int elements = DECK_SIZE - x;
        int n = (random() % elements) + x;
        [deck exchangeObjectAtIndex:x withObjectAtIndex:n];
    }
}

- (void) dealDeck
{
	self.readyPlay = NO;
	
    [self removeAllChildrenWithCleanup:YES];

    CGSize window_size = [[CCDirector sharedDirector] winSize];
    
	//[[CCDirector sharedDirector] set
   // CGPoint offscreen = ccp((float)window_size.width/2, (float)0);
//    CGPoint origin = ccp((float)55, (float)370);
//	
    MYLog();
	NSLog(@"winsize w  %f  h %f ", window_size.width,window_size.height);
	
	CGPoint offscreen = ccp((float)window_size.width/2, (float)window_size.height/2);
    //CGPoint origin = ccp((float)FIRST_CARD_CENTER_X, (float)FIRST_CARD_CENTER_Y);
	//CGPoint origin = ccp((float)86, 348.0);//window_size.height - (float)36);
	CGPoint origin = ccp((float)CARD_WIDTH/2, CARD_HEIGHT/2);//window_size.height - (float)36);
	
	float interval_x = (CROP_BACK_W - CARD_WIDTH*4)/3 ;
	float  interval_y = (CROP_BACK_H - CARD_HEIGHT*2);
	float increase_x = interval_x + CARD_WIDTH;
	float increase_y= interval_y + CARD_HEIGHT;	
	
	for (int x = 0,y= 1; x < DECK_SIZE; x++, y++)
	{
        Card *card = [deck objectAtIndex:x];
        [[card getCurrentView] setPosition:offscreen];
		[self addChild: [card getCurrentView]];
        
		
		//fshi
	
		
        //animation of cards is here
        [[card getCurrentView] runAction:[CCMoveTo actionWithDuration:.1 position:origin]];
        [[card getCurrentView] runAction:[CCRotateBy actionWithDuration:.1 angle:360]];

		[card set_table_location:CGRectMake(origin.x - CARD_WIDTH / 2 , origin.y - CARD_HEIGHT / 2, CARD_WIDTH, CARD_HEIGHT)];
		
        //Changing row/column points. I could probably do this better.
        if (y==4)
		{
            origin.y += increase_y;
            origin.x = CARD_WIDTH/2;
            y = 0;
		} else {
			origin.x += increase_x;
		}
	}
	
	self.readyPlay = YES;
	
}

- (BOOL) inMatch
{
    return in_match;
}


//I'm not sure if the next two methods are the correct way to interact with a HUD layer.
- (void) incrementScore
{
    score += 1;
	NSLog(@"score %d \n",score);
	if (score == 4) {
		//success
		NSLog(@"OKAY");
		resultSprite = [CCSprite spriteWithFile:@"congratulations1.png"];
		[resultSprite setPosition:ccp(CROP_BACK_W/2 ,CROP_BACK_H/2 )];
		[resultSprite setScale:0.6];
		[self addChild:resultSprite z:3];
		
		//[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(backToCoverFlow) userInfo:nil repeats:NO];
		
	}
  //  [hud setScore:score];
}

- (void) resetScore
{
    score = 0;
   // [hud setScore:score];
}


-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
//	if (!self.readyPlay) {
//		return;
//	}
	UITouch *touch   = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint cLoc     = [[CCDirector sharedDirector] convertToGL: location];
    
    // this should be broken out into a separate function that returns the
    // card if it was touched and "in play".
    for (int x = 0; x < DECK_SIZE; x++) 
    {
        Card *card = [deck objectAtIndex:x];
        
        if (card.is_matched)
        {
            continue;
        }
        
        if (CGRectContainsPoint(card._table_location, cLoc))
        {       
            if (card == first_card) 
            {
#ifdef DEBUG 
				NSLog(@"YES, matched new ");
#endif
                [self flipCard:card];
                first_card = NULL;
               // [self incrementScore];
                return ;//kEventHandled;
            } else if ([card is_matched]) 
            {
#ifdef DEBUG 
				NSLog(@"matched !");
#endif
                return ;//kEventHandled;
            }
            
            if (first_card) 
            {
                [self flipCard:card];
                in_match = YES;
                second_card = card;
                [self schedule:@selector(check_selection:) interval:0.1];
               // [self incrementScore];
            } else {
                [self flipCard:card];
                first_card = card;
            }
            return ;//kEventHandled;
        }
    }
	return ;//kEventIgnored;
}

//find, remove the sprite, flip the state, redraw the card in the same place
- (void)flipCard:(Card *)card
{
    CGPoint origin = [[card getCurrentView] position];
    [self removeChild:[card getCurrentView] cleanup:YES];
    
    [card flip];
    
    [self addChild:[card getCurrentView]];
    [[card getCurrentView] setPosition: origin];
}

-(void) check_selection: (ccTime) dt
{
    if (first_card.value == second_card.value) 
    {
        first_card.is_matched = YES;
        second_card.is_matched = YES;
        
        first_card = NULL;
        second_card = NULL;
        
        in_match = NO;
		
		//fshi
		[self incrementScore];
    } else {
        [self flipCard:first_card];
        [self flipCard:second_card];
        
        in_match = NO;
        
        first_card = NULL;
        second_card = NULL;
    }
    
    [self unschedule:@selector(check_selection:)];
}
@end
